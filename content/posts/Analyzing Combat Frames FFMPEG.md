---
title: "Analyzing Combat Frames with FFMPEG"
date: 2022-01-10T22:25:52-08:00
draft: false
tags: ['Breakdown']
# featuredImage: "/images/CrowReaper.png"
featuredImagePreview: "/images/CrowReaper.png"
---

<!-- # Header 1
## Lesser Header 1
My first post

# Header 2
## Lesser Header 2
My first post -->

When analyzing combat in other studio's games or in the combat of games I'm currently developing, I find it useful to be able to split out individual frames of recorded video of gameplay in order to step through the frames of the game one by one.

## Recommended Tools
Download [FFmpeg](https://ffmpeg.org/).


## Previewing ffmpeg settings
Preview video frames with **ffplay** 

```bat
@REM For each *.mp4 file in the current directory, play it with the current settings.
for %%A IN (*.mp4) DO ffplay -i "%%A" -vf "crop=2560:1920"

pause
```


## Batch Exporting of Frames
Dump video frames with **ffmpeg** 
```bat
@REM For each *.mp4 file in the current directory make a folder with the same name as the .mp4 file name
@REM and then output individual files of the .mp4 into the newly created directory with the same name.
for %%A IN (*.mp4) DO mkdir "%%~nA" 
for %%A IN (*.mp4) DO ffmpeg -ss 00:00:00 -i "%%A" -vf "crop=2560:1920" "%%~nA\image%%04d.png" 

pause
```

![Image1](/images/CrowReaper.png)
![Image2](/images/ChompyHead.png)

<!-- {{< mermaid >}}
stateDiagram
    [*] --> Still
    Still --> [*]
    Still --> Moving
    Moving --> Still
    Moving --> Crash
    Crash --> [*]
{{< /mermaid >}} -->



