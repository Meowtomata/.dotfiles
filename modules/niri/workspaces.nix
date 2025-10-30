{ ... }:
{

  programs.niri = {
    settings = {
      workspaces."1-Unstructured" = {
        name = "Unstructured";
      };
      workspaces."2-Coding" = {
        name = "Coding";
      };
      workspaces."3-HW" = {
        name = "HW";
      };
      workspaces."4-TA" = {
        name = "TA";
      };
      workspaces."5-Music" = {
        name = "Music Production";
      };
      workspaces."6-Video" = {
        name = "Video Production";
      };
      workspaces."7-Leisure" = {
        name = "Leisure";
      };
      workspaces."8-Config" = {
        name = "Configuration";
      };
      workspaces."9-Journal" = {
        name = "Journal";
      };
    };
  };
}
