echo "src-link  vizos  ../feeds-vizos" >> feeds.conf.default
cat feeds.conf.default
./scripts/feeds update  -a
./scripts/feeds install -a
./scripts/feeds install -f sophgo
./scripts/feeds install -f uboot-sophgo

echo '请选择开发板型号:'
echo '1.milkv-duo'
echo '2.milkv-duo256m'
echo '3.milkv-duos'
echo '4.cv181x boards'
read board

case "$board" in
"1")
    cp ../feeds-vizos/cofigs/cv180x-config .config
;;
"2")
    cp ../feeds-vizos/configs/cv181x-milkv-duo256m-config .config
;;
"3")
    cp ../feeds-vizos/configs/cv181x-milkv-duos-config .config
;;
"4")
    cp ../feeds-vizos/configs/cv180x-config .config
;;
esac

echo -e "$(nproc) thread compile"
make -j$(nproc) || make package/feeds/vizos/uboot-sophgo/compile V=s
make -j8 V=s
echo "::set-output name=status::success"
