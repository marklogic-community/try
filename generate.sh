echo "/* codemirror.js */

" > /tmp/tryml.js
cat CodeMirror2/lib/codemirror.js >> /tmp/tryml.js

echo "/* htmlmixed.js */

" >> /tmp/tryml.js
cat CodeMirror2/mode/htmlmixed.js >> /tmp/tryml.js

echo "/* javascript.js */

" >> /tmp/tryml.js
cat CodeMirror2/mode/javascript.js >> /tmp/tryml.js

echo "
/* xml.js */

" >> /tmp/tryml.js
cat CodeMirror2/mode/xml.js >> /tmp/tryml.js

echo "
/* xquery.js */

" >> /tmp/tryml.js
cat CodeMirror2/mode/xquery.js >> /tmp/tryml.js

echo "
/* json2.js */

" >> /tmp/tryml.js
cat js/json2.js >> /tmp/tryml.js

echo "
/* base.js */

" >> /tmp/tryml.js
cat js/base.js >> /tmp/tryml.js

if [ "$OSTYPE" == "darwin" ] ; then
./jsmin.osx < /tmp/tryml.js > js/tryml.js
else
./jsmin < /tmp/tryml.js > js/tryml.js
fi

rm /tmp/tryml.js




echo "
/* base.css */

" > css/tryml.css
cat css/base.css >> css/tryml.css

echo "
/* codemirror.css */

" >> css/tryml.css
cat CodeMirror2/lib/codemirror.css >> css/tryml.css

echo "
/* default.css */

" >> css/tryml.css
cat CodeMirror2/theme/default.css >> css/tryml.css
