rm compile_flags.txt
echo -xc++ >>compile_flags.txt
find ./ -name "*.h" | xargs dirname >>temp1.txt
sed "s/^/-I&/g" temp1.txt >>compile_flags.txt
echo -I /usr/lib >>compile_flags.txt
echo -I /usr/include >>compile_flags.txt
echo -I /usr/local/include/ >>compile_flags.txt
rm temp1.txt
