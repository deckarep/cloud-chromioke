#!/bin/bash
echo "Cleaning up..."
rm -f output.mp4
rm -rf tmpdir
mkdir -p tmpdir

echo "Generating all frames..."
frame_dumper input.cdg tmpdir

echo "Generating .mp4 file..."
ffmpeg -r 25 \
  -i tmpdir/frame_%05d.png \
  -i input.mp3 \
  -c:v libx264 \
  -profile:v high \
  -level 5 \
  -crf 18 \
  -maxrate 10M \
  -bufsize 16M \
  -pix_fmt yuv420p \
  -vf "scale=iw*sar:ih,scale='if(gt(iw,ih),min(1920,iw),-1)':'if(gt(iw,ih),-1,min(1080,ih))'" \
  -x264opts bframes=3:cabac=1 \
  -movflags faststart \
  -c:a aac \
  -strict -2 \
  -b:a 320k \
  -y output.mp4