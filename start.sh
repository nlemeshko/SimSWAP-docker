#!/bin/bash
TIMESTAMP=`date +%Y-%m-%d_%H-%M-%S`

echo "Don't remember download files to sources path"
echo Type name of Imagefile
read imagefile
echo Type name of Videofile
read videofile
docker run --rm -it -v ${PWD}/source:/home/source mdsn/simswap /opt/conda/envs/simswap/bin/python test_video_swapsingle.py --isTrain false  --name people --Arc_path arcface_model/arcface_checkpoint.tar --pic_a_path /home/source/$imagefile --video_path /home/source/$videofile --output_path /home/sources/video$TIMESTAMP.mp4 --temp_path ./temp_results