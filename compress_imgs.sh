#!/bin/bash

# 指定输入文件夹和输出文件夹路径
input_folder="02learning_notes/computer_graphics/games101/_imgs"
output_folder="processed"

# 压缩后的文件都放在 processed 最后手动替换！
mkdir "$output_folder"

# 遍历输入文件夹中的所有图片文件，包括子文件夹
find "$input_folder" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) | while read -r file; do
  # 获取文件路径、文件名和扩展名
  filepath=$(dirname "$file")
  filename=$(basename "$file")
  extension="${filename##*.}"

  # 设置输出文件路径
  relative_path="${filepath#$input_folder}"
  output_file="$output_folder${relative_path}/${filename%.*}.$extension"
  # 可以加 _compressed 后缀

  # 创建输出文件夹（如果不存在）
  mkdir -p "$(dirname "$output_file")"
  echo "压缩开始: $file"

  # 使用FFmpeg进行图片压缩 open it 
  ffmpeg -i "$file" -vf "scale=-1:480" -q:v 2 "$output_file" -nostdin

  echo "压缩完成: $output_file"
done

# 统计压缩前文件数量
original_count=$(find "$input_folder" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \)  | wc -l | xargs)

# 统计压缩后文件数量
compressed_count=$(find "$output_folder" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) | wc -l | xargs)

# 比较文件数量
if [ "$original_count" -eq "$compressed_count" ]; then
  echo "压缩前后文件数量一致：$original_count"
else
  echo "压缩前后文件数量不一致：压缩前：$original_count ，压缩后：$compressed_count"
fi

# 统计压缩前文件总大小
original_size=$(find "$input_folder" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) -exec du -ch {} + | grep total$ | awk '{print $1}')

# 统计压缩后文件总大小
compressed_size=$(find "$output_folder" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) -exec du -ch {} + | grep total$ | awk '{print $1}')

# 比较文件大小
echo "压缩前总大小: $original_size"
echo "压缩后总大小: $compressed_size"
