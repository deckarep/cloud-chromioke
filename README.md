# cloud-chromioke
Chromecast Karaoke in the Cloud

# How it works

## CDG Frame Dump
A rust application that concerns itself with taking a genuine .CDG file
and spinning through the data generating n .png frames.  This will
generate on the order of a few hundred frames and these will be melded
along with the original `.mp3` file into ffmpeg in the next step.

## FFmpeg
Data is processed as a series of .png frames along with the original
`input.mp3`. This means the ffmpeg command must combine this data into a
format that is honored by the Chromecast.

```sh
fmpeg -r 25 -i tmpdir/frame_%05d.png -i input.mp3 
  -c:v libx264
  -profile:v high
  -level 5
  -crf 18
  -maxrate 10M
  -bufsize 16M
  -pix_fmt yuv420p
  -vf "scale=iw*sar:ih,scale='if(gt(iw,ih),min(1920,iw),-1)':'if(gt(iw,ih),-1,min(1080,ih))'"
  -x264opts bframes=3:cabac=1
  -movflags faststart
  -c:a aac
  -b:a 320k
  -y output.mp4
```

Notice the input is a temp directory with all the .png frames along with
the `input.mp3` file containing the audio.

The output is then a single file: `output.mp4' which is the final video
file.

## Casting
Casting is done with the Castnow node.js command-line tool as follows:

```sh
castnow --address 10.0.0.32 --type "video/mp4" output.mp4
```

Where the address is that of your Chromecast which you can get from your
Google Home app in the Settings section.

## Building
```sh
docker build -t cdg .
```

## Running the server
```sh
docker run -it -v=`pwd`:/tmpdir -p 0.0.0.0:8080:8080 cdg
```

## Processing a music file.
```sh
docker run -v=`pwd`:/tmpdir --entrypoint="./process.sh" cdg "{artist - song.zip}"
```
