# echo "src-link  vizos  ../feeds-vizos" >> feeds.conf.default
cat feeds.conf.default
echo -e "\033[32mInstalling the packages now...\033[0m"
./scripts/feeds update  -a
./scripts/feeds install -a
./scripts/feeds install -f sophgo
./scripts/feeds install -f uboot-sophgo

echo -e '\033[32mSelect a target to build:\033[0m'
echo '1.milkv-duo'
echo '2.milkv-duo256m'
echo '3.milkv-duos'
echo '4.cv181x boards'
read board

case "$board" in
"1")
    cp ./feeds/vizos/cofigs/cv180x-config .config
;;
"2")
    cp ./feeds/vizos/configs/cv181x-milkv-duo256m-config .config
;;
"3")
    cp ./feeds/vizos/configs/cv181x-milkv-duos-config .config
;;
"4")
    cp ./feeds/vizos/configs/cv181x-config .config
;;
esac

if [ -d "/opt/host-tools/gcc/riscv64-linux-musl-x86_64" ]; then
    echo 'the host-tools exits.'
elif [ -d "./host-tools/gcc/riscv64-linux-musl-x86_64" ]; then
    sed -i 's|/opt/host-tools/gcc/riscv64-linux-musl-x86_64|./host-tools/gcc/riscv64-linux-musl-x86_64|g' .config
    echo 'the host-tools exits.'
else
    echo -e '\033[32mthe host-tools not exits, downloading it now...\033[0m'
    sed -i 's|/opt/host-tools/gcc/riscv64-linux-musl-x86_64|./host-tools/gcc/riscv64-linux-musl-x86_64|g' .config
    git clone https://github.com/milkv-duo/host-tools.git
fi

echo -e "\033[32m$(nproc) thread compile.\033[0m"
make download -j$(nproc)
make -j$(nproc) || make package/feeds/vizos/uboot-sophgo/compile V=s
make -j$(nproc) V=s
echo -e "\033[32mThe $board milkv-duo board build successful.\033[0m"
