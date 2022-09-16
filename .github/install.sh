
apktool(){ java -jar $Likk/Tools/kikfox.jar "$@"; }
Taive () { curl -s -L --connect-timeout 20 "$1" -o "$2"; }
Xem () { curl -s -G -L --connect-timeout 20 "$1"; }
apksign () { java -jar $Likk/Tools/apksigner.jar sign --cert "$Likk/Tools/testkey.x509.pem" --key "$Likk/Tools/testkey.pk8" --out "$2" "$1"; }
XHex(){ xxd -p "$@" | tr -d "\n" | tr -d ' '; }
ZHex(){ xxd -r -p "$@"; }
apktoolur(){
apktool d -rs -m -f "$1" -o "$Likk/Nn"
rm -fr "$Likk/Nn"/assets/fonts/*
apktool b -c "$Likk/Nn" -f -o "$Likk/Nn.apk"
cp -rf "$Likk/Nn.apk" "$1"
}
cpnn(){
while true; do
[ -e "$Likk/tmp/res/values-vi/strings.xml" ] && break || sleep 1
done
sleep 2
for vakdll in $Likk/Language/*; do
if [ -e $vakdll/strings.xml ];then
cat $vakdll/strings.xml >> $Likk/tmp/res/${vakdll##*/}/strings.xml
sed -i "/<\/resources>/d" $Likk/tmp/res/${vakdll##*/}/strings.xml
echo '</resources>' >> $Likk/tmp/res/${vakdll##*/}/strings.xml
fi
done
Taiyt 'YouTube.apks'
unzip -qo $Likk/lib/YouTube.apks 'base.apk' -d $Likk/Tav
while true; do
[ -e "$Likk/done.txt" ] && break || sleep 1
done
sleep 2
}

ListTM="lib
tmp
Up
Nn
Tav
Pak
apk"

for Vak in $ListTM; do
mkdir -p $Vak
done

echo "- Tải xuống công cụ cli..."

# Tải tool Revanced
Tv1="$(Xem https://github.com/revanced/revanced-cli/releases | grep '/releases/download' | grep -m1 '.jar' | cut -d \" -f2)"
Taive "https://github.com$Tv1" "$Likk/lib/revanced-cli.jar"
Tv2="$(Xem https://github.com/revanced/revanced-patches/releases | grep '/releases/download' | grep -m1 '.jar' | cut -d \" -f2)"
Taive "https://github.com$Tv2" "$Likk/lib/revanced-patches.jar"
Tv3="$(Xem https://github.com/revanced/revanced-integrations/releases | grep '/releases/download' | grep -m1 '.apk' | cut -d \" -f2)"
Taive "https://github.com$Tv3" "$Likk/lib/revanced-integrations.apk"

# Tải Youtube
Vidon="$(java -jar $Likk/lib/revanced-cli.jar -a $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -l --with-versions | grep -m1 hide-shorts-button | tr ',' '\n' | tac | head -n 1 | awk '{print $1}')"
[ "$VERSION" ] || VERSION="$Vidon"
Kvision="$(echo $VERSION | tr '.' '-')"
Vision2="$(echo $VERSION | sed 's|.||g')"

Taiyt () {
Upk="https://www.apkmirror.com"
User="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"
Url1="$(curl -s -k -L -G -H "$User" "$Upk/apk/google-inc/youtube/youtube-$Kvision-release/youtube-$Kvision$2-android-apk-download/" | grep -m1 'downloadButton' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
Url2="$Upk$(curl -s -k -L -G -H "$User" "$Upk$Url1" | grep -m1 '>here<' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
curl -s -k -L -H "$User" $Url2 -o $Likk/lib/$1
}

echo "- Tải xuống YouTube: $VERSION"
Taiyt 'YouTube.apk' '-2'
[ -e $Likk/lib/YouTube.apk ] || (echo "- Lỗi tải Youtube.apk"; logout)

if [ "$DEVICE" == "arm64-v8a" ];then
lib="lib/x86/* lib/x86_64/* lib/armeabi-v7a/*"
ach="arm64"
elif [ "$DEVICE" == "x86" ];then
lib="lib/x86_64/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x86"
elif [ "$DEVICE" == "x86_64" ];then
lib="lib/x86/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x64"
else
lib="lib/arm64-v8a/* lib/x86/* lib/x86_64/*"
ach="arm"
fi

echo > $Likk/Module/common/$ach
cp -rf $Likk/Tools/sqlite3_$ach $Likk/Module/common/sqlite3

unzip -qo "$Likk/lib/YouTube.apk" "lib/$DEVICE/*" -d $Likk/Tav
[ "$DEVICE" == 'x86' ] || mv -f $Likk/Tav/lib/$DEVICE $Likk/Tav/lib/$ach

[ "$ROUND" == 'true' ] || rm -fr $Likk/Module/system
[ "$ICONS" == 'true' ] && echo -n "-e custom-branding " >> $Likk/logk
[ "$SHORTS" == 'true' ] && echo -n "-e hide-shorts-button " >> $Likk/logk
[ "$CREATE" == 'true' ] && echo -n "-e disable-create-button " >> $Likk/logk
[ "$TYPE" != 'true' ] && lib='lib/*/*'

zip -qr "$Likk/lib/YouTube.apk" -d $lib

if [ "$AMOLED" == 'true' ];then
echo -n "-e amoled " >> $Likk/logk
else
amoled2=".Amoled"
fi

for vakl in $FEATURE; do
echo -n "-e $vakl " >> $Likk/logk
done

echo '
version='$VERSION'
versionCode='$Vision2'
updateJson=https://github.com/'$GITHUB_REPOSITORY'/releases/download/Up/Up-'$ach$amoled2'.json' >> $Likk/Module/module.prop

# Xử lý revanced patches
if [ "$Vidon" != "$VERSION" ];then
unzip -qo "$Likk/lib/revanced-patches.jar" -d $Likk/Pak
for vak in $(grep -Rl "$Vidon" $Likk/Pak); do
cp -rf $vak $Likk/tmp/test
XHex "$Likk/tmp/test" | sed -e "s/$(echo -n "$Vidon" | XHex)/$(echo -n "$VERSION" | XHex)/" | ZHex > $vak
done
cd $Likk/Pak
zip -qr "$Likk/lib/revanced-patches.jar" *
fi

# Xây dựng 
echo "- Xây dựng..."
if [ "$TYPE" != 'true' ];then
( java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube.apk" -o "$Likk/Tav/YouTube.apk" -t $Likk/tmp $(cat $Likk/logk) -e microg-support --mount
[ "$OPTIMIZATION" == 'true' ] && apktoolur "$Likk/Tav/YouTube.apk"
cd $Likk/Tav
tar -cf - * | xz -9kz > $Likk/Module/common/lib.tar.xz
cd $Likk/Module
zip -q -r "$Likk/Up/YouTube-Magisk-$VERSION-$ach$amoled2.Zip" *
echo '{
"version": "'$VERSION'",
"versionCode": "'$Vision2'",
"zipUrl": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/V'$Kvision'/YouTube-Magisk-'$VERSION'-'$ach$amoled2'.Zip",
"changelog": "https://raw.githubusercontent.com/'$GITHUB_REPOSITORY'/Vip/Zhaglog.md"
}' > $Likk/Up-$ach$amoled2.json 
echo > $Likk/done.txt ) & cpnn
else
( java -jar $Likk/lib/revanced-cli.jar -m $Likk/lib/revanced-integrations.apk -b $Likk/lib/revanced-patches.jar -a "$Likk/lib/YouTube.apk" -o "$Likk/apk/YouTube.apk" -t $Likk/tmp $(cat $Likk/logk) --mount
[ "$OPTIMIZATION" == 'true' ] && apktoolur "$Likk/apk/YouTube.apk"
apksign "$Likk/apk/YouTube.apk" "$Likk/Up/YouTube-NoRoot-$VERSION-$ach$amoled2.apk" 
cp -rf "$Likk/Tools/Microg.apk" "$Likk/Up"
echo > $Likk/done.txt ) & cpnn
fi

echo "- Hoàn thành."