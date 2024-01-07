#!/bin/bash

# 指定包含网站链接的文件路径
input_file="chinois.txt"

# 循环读取文件中的每个链接
while IFS= read -r url
do
    # 使用lynx命令获取网页内容，并将输出保存到以链接名为基础的文件中
    lynx -dump "$url" > "$(basename "$url").txt"

    # 或者，如果你想要合并所有输出到一个文件中，可以使用追加重定向
    # lynx -dump "$url" >> "all_output.txt"
done < "$input_file"

