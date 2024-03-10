# Multilanguage test map

Spanish: "Traditional Sort"

Chinese: CN = Simplified, China. TW = Traditional, Taiwan

## Copy and rename

```bash
rm -rf -- "./generated-wts/"

for langcode in "dede" "enus" "eses" "esmx" "frfr" "itit" "kokr" "plpl" "ptbr" "ruru" "zhcn" "zhtw" "DEFAULT" "hungarian" "thai" "turkish" "japanese" "czech"; do
	mkdir -p "./generated-wts/reforged/_locales/${langcode}.w3mod" "./generated-wts/classic"

	test -f war3map.wts \
	&& cat war3map.wts | sed -e "s/{LANGCODE}/${langcode}.classic/g" > "./generated-wts/classic/war3map-$langcode.wts" \
	&& cat war3map.wts | sed -e "s/{LANGCODE}/${langcode}.reforged/g" > "./generated-wts/reforged/_locales/${langcode}.w3mod/war3map.wts"

done
```

## Test map

`sha1sum: e05eb1c2973ce1ab353809af00701a6ff5b46224  1.24a-Lang-Test.w3m`

Contains these languages: default means Neutral (0000)

`"dede" "enus" "eses" "esmx" "frfr" "itit" "kokr" "plpl" "ptbr" "ruru" "zhcn" "zhtw" "DEFAULT" "hungarian" "thai" "turkish" "japanese" "czech"`
