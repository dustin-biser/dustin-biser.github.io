---
title: "Analyzing Combat Frames with FFmpeg"
date: 2022-02-01
draft: false
tags: ['Tools', 'Analysis']
# featuredImage: "/images/CrowReaper.png"
featuredImagePreview: "/images/CrowReaper.png"
summary: "Example of using FFmpeg to answer questions about combat"
---

### Answering Key Questions

I often find myself analyzing the combat of action games that I enjoy playing.  Doing so helps me answer questions such as:
* What makes the character's attacks and abilities feel so satisfying? 
* Why are combat encounters so enjoyable in this game?  
* Why does my character feel like an unstoppable force of nature?
* What makes the controls and character movement feel so fluid?


Conversely, I also find it educating to analyze the combat of games I find frustrating.  In doing so, I try to answer questions like:
* Why do I feel overwhelmed when multiple enemies are on screen at once?
* Why does my parry not come out on time to counter the enemy's attack?
* Why do these controls feel unresponsive?


In order to answer these questions, I like to use FFmpeg to export individual frames of recorded gameplay so that I can step through the action frame-by-frame to better understand what is happening and why it might elicit a specific feeling.


> __Disclaimer:__ Examples covered in this article can be achieved with various other programs and software.  FFmpeg is not the only tool that allows scrubbing through individual frames of video.  It just happens to be one of the few _free_ tools that is also powerful and flexible, which is why I use it for my own work and recommend it to others.


### Frame Exporting Workflow

We'll be using the following workflow that allows for quick adjustment and iteration of exporting video frames so we can export only the frames we care about with the option to crop and scale the frames as needed.


{{< mermaid >}}
graph LR;
    A(Record Gameplay Video) --> B(Trim Video to Specific Section)
    B --> C(Preview Scale/Crop Settings)
    C -->E(Export Frames)
{{< /mermaid >}}



### Recommended Tools and Setup

First, grab a copy of FFmpeg if you don't already have the program.

Link to download [FFmpeg](https://ffmpeg.org/).


Once you download FFmpeg, copy `ffmpeg.exe` and `ffplay.exe` into a custom folder along with the .mp4 gameplay video you would like to analyze, like so: 

```
\CustomFolder
    - ffmpeg.exe
    - ffplay.exe
    - GameplayVideo.mp4
```

&nbsp;
{{< admonition type=tip title="Tip" open=true >}}
For recording your `GameplayVideo.mp4`, there are many software programs available, but if you happen to have an Nvidia GPU, then Nvidia Shadowplay is a great free choice which allows syncing video to 60fps so no gameplay frames are lost during recording.
{{< /admonition >}}

### Trimming Video 

It's common to record a longer play session of gameplay and then go back and analyze smaller sections of the video later.  That's where the first stage of this workflow comes in. We can tell FFmpeg to copy a smaller section of our gameplay video to a new video that'll we analyze in detail afterward.

To do this, create a new file `TrimVideo.bat` and place it in your `CustomFolder`.

```
\CustomFolder
    - TrimVideo.bat <--
    - ffmpeg.exe
    - ffplay.exe
    - GameplayVideo.mp4
```

Then copy and paste the following text into `TrimVideo.bat`.

```bat
:: Loop over all ".mp4" video files in the current directory 
:: and trim/copy the video to a new file called "[VideoName] trimmed.mp4"
:: -ss hh:mm:ss, sets the start time (h:hours, m:minutes, s:seconds)
:: -t hh:mm:ss, sets the end time (h:hours, m:minutes, s:seconds)
for %%A IN (*.mp4) DO ffmpeg -ss 00:00:02 -t 00:00:10 -i "%%A" -c copy "%%~nA trimmed.mp4"
pause
```
 This script will take any .mp4 video in the current directory and copy it to a new file called `[VideoName] trimmed.mp4` with a start time of 2 seconds, and an end time of 10 seconds.  Feel free to change the start and end time to fit your needs.


With all the files listed in the `\CustomFolder` above, you can now double click to run `TrimVideo.bat`, which will create a new file called `GameplayVideo trimmed.mp4`, which is our shorter, trimmed copy of our original gameplay video. 

If the trimmed .mp4 video looks good, you can now remove the original `GameplayVideo.mp4` from the `\CustomFolder` directory.  Your `\CustomFolder` should now contain following:

```
\CustomFolder
    - TrimVideo.bat
    - ffmpeg.exe
    - ffplay.exe
    - GameplayVideo trimmed.mp4 <--
```


### Preview Settings Before Export
Next we'll write a short script to allow us to preview the contents of `GameplayVideo trimmed.mp4` so that we can test out scaling and cropping parameters quickly before exporting all the individual frames.

Create a `PreviewFrames.bat` file and copy paste the following code into it.


```bat
:: For each *.mp4 file in the current directory, preview it with the following settings:
:: scale=-1:1080, resize to 1080 pixels vertically, while maintaining aspect ratio of video.
:: crop=width:height, from center of video
for %%A IN (*.mp4) DO ffplay -i "%%A" -vf "scale=-1:1080, crop=1024:720"
pause
```

&nbsp;

Then place the `PreviewFrames.bat` file into our `CustomFolder` like so:

```
\CustomFolder
    - PreviewFrames.bat <--
    - TrimVideo.bat
    - ffmpeg.exe
    - ffplay.exe
    - GameplayVideo trimmed.mp4
```
&nbsp;

Now you can double click and run `PreviewFrames.bat` which will preview your `GameplayVideo trimmed.mp4` in real-time with the scale and cropped size options specified. Pressing `SpaceBar` allows you to pause and resume the preview video as needed.

Try out different settings for the `-vf "scale=-1:1080, crop=1024:720"` options to see what works best for your video. 

* `-vf "crop=700:500:20:30"` - Keep the same video scale resolution, but crop the video with an offset starting from x=20, y=30 pixels from the top-left corner with width=700 pixels and height=500 pixels.

* `-vf "scale=1280:720` - Scale the video's resolution so that it's 1280 pixels wide and 720 pixels tall.  Don't apply any cropping. 

Once the preview looks good with the specified size and crop settings we can then move on to creating our batch file for exporting the individual video frames.


### Exporting Frames

Next we'll create our final script called `ExportFrames.bat` and place it in our `\CustomFolder` directory like so:

```
\CustomFolder
    - ExportFrames.bat <--
    - PreviewFrames.bat
    - TrimVideo.bat
    - ffmpeg.exe
    - ffplay.exe
    - GameplayVideo trimmed.mp4
```

Then copy the following text into our `ExportFrames.bat` file:

```bat
:: For each *.mp4 file in the current directory make a new folder with the same name
:: and export the individual frames of the .mp4 into the new folder.
for %%A IN (*.mp4) DO mkdir "%%~nA Frames" 
for %%A IN (*.mp4) DO ffmpeg  -i "%%A" -vf "scale=-1:1080, crop=1024:720" ^
"%%~nA Frames\image%%04d.png" 
pause
```

Make sure to copy the same scale and crop arguments used previously in `PreviewFrames.bat` to our new script above.  Then we can double click to run `ExportFrames.bat` and a new folder will be created called `\GameplayVideo trimmed Frames` containing all the exported frames from the .mp4 video.



```
\CustomFolder
    \GameplayVideo trimmed Frames <--
    - ExportFrames.bat
    - PreviewFrames.bat
    - TrimVideo.bat
    - ffmpeg.exe
    - ffplay.exe
    - GameplayVideo trimmed.mp4
```


### Scrubbing Through Exported Frames

<!-- ![Image1](/images/CrowReaper.png) -->

<!-- ![Image2](/images/ChompyHead.png) -->



<!-- Example Video>

<!-- {{< rawhtml >}} 

<video width=100% controls autoplay loop>
    <source src="/videos/JediMap.mp4" type="video/mp4">
    Your browser does not support the video tag.  
</video>

{{< /rawhtml >}} -->


