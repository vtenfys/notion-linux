const current_release = "v2.0.11-3";
const latest_release_url =
  "https://github.com/davidbailey00/notion-linux-builder/releases/latest";
fetch(
  "https://api.github.com/repos/davidbailey00/notion-linux-builder/releases"
)
  .then((res) => res.json())
  .then((releases) => {
    if (releases[0].tag_name !== current_release)
      require("open")(latest_release_url);
  });
