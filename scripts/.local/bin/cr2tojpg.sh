for f in *.CR2; do
  darktable-cli "$f" "jpg/${f%.CR2}.jpg" \
    --core --conf plugins/imageio/format/jpeg/quality=100
done
