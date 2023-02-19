import { Octokit } from "@octokit/core";
import { existsSync } from "fs";
import { mkdir, rm, writeFile } from "fs/promises";
import fetch from "node-fetch";
import { join } from "path";
import { fileURLToPath } from "url";

const __dirname = fileURLToPath(new URL(".", import.meta.url));
const debDir = join(__dirname, "../public/pool/main/github-desktop");
/** How many debs would be deployed */
const debCount = 5;

const octokit = new Octokit();
const { data: releases } = await octokit.request("GET /repos/{owner}/{repo}/releases", {
  owner: "shiftkey",
  repo: "desktop",
  per_page: debCount,
});
const debs = releases.map(release => {
  const { browser_download_url } = release.assets.find(asset => asset.browser_download_url.endsWith(".deb"));
  return {
    url: browser_download_url,
    tag: release.tag_name,
  }
});

if (existsSync(debDir)) {
  await rm(debDir, { recursive: true });
}
await mkdir(debDir, { recursive: true });

for (const deb of debs) {
  const res = await fetch(deb.url);
  const arrayBuffer = await res.arrayBuffer();
  const [ _, version, releaseNumber ] = (/^release-([0-9\.]*)-linux([0-9]+)$/i).exec(deb.tag)
  const outFileName = `github-desktop_${version}-linux${releaseNumber}_all.deb`;

  await writeFile(join(debDir, outFileName), Buffer.from(arrayBuffer));

  console.info(`Saved ${outFileName}`);
}
