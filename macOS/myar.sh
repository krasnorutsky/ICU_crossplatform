if [ -z "$4" ] ;then
    if [ -z "$3" ] ;then
        echo "do 2"
        lipo -create -output $1 $2
    else
        echo "do 3"
        lipo -create -output $2 $3
    fi
else
    echo "do 4"
    lipo -create -output $3 $4
fi

exit 0

