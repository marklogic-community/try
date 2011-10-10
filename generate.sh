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

./jsmin < /tmp/tryml.js > js/tryml.js

rm /tmp/tryml.js
