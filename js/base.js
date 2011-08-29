/*
    XXX:
      • output multiples
*/
if(typeof tryml == "undefined" || !tryml) {
    tryml = {};
}

tryml.editors = {};

$.fn.replaceWithReturningNew = function () {
    var ret = $(arguments[0]);
    this.replaceWith(ret);
    return ret;
};

tryml.blockToParserConfig = function(block, type) {
    var config = {
        path: "/CodeMirror/js/",
        continuousScanning: false,
        lineNumbers: true,
        textWrapping: false,
        readOnly: false
    };

    if(type === "output") {
        config.reindentOnLoad = true;
        config.height = "dynamic";
    }
    else if(type === "input") {
        config.height = "dynamic";
    }

    if(block.hasClass("readonly") || type === "output") {
        config.readOnly = true;
    }

    if(block.hasClass(type + "-xquery")) {
        config.parserfile = ["tokenizexquery.js", "parsexquery.js"];
        config.stylesheet = ["/CodeMirror/css/xqcolors2.css"];
    }
    else if(block.hasClass(type + "-xml")) {
        config.parserfile = ["parsexml.js"];
        config.stylesheet = ["/CodeMirror/css/xmlcolors.css"];
    }
    else if(block.hasClass(type + "-javascript")) {
        config.parserfile = ["tokenizejavascript.js", "parsejavascript.js"];
        config.stylesheet = ["/CodeMirror/css/jscolors.css"];
    }

    return config;
};

tryml.setupDOM = function(block, editorId) {
    var outputFormat = undefined;
    var classes = block.attr('class').split(/\s+/);
    var outputType = undefined;
    $.each(classes, function(index, className) {
        if(className.substring(0, 7) === "output-") {
            outputType = className.substring(7);
        }
    });

    if(outputType !== undefined) {
        var outputConfig = undefined;
        var outputEditor = undefined;

        if(outputType !== "html") {
            outputConfig = tryml.blockToParserConfig(block, "output");
        }

        var container = $(block).replaceWithReturningNew("<div id='" + editorId + "' class='codeContainer'><div class='inputContainer'></div><button class='submit'>Submit</button><div class='outputContainer'></div><div class='errorContainer'></div></div>");

        var outputContainer = container.find("div.outputContainer");
        outputContainer.hide();

        if(outputType !== "html") {
            outputEditor = new CodeMirror(outputContainer.get(0), outputConfig);
        }

        var errorContainer = container.find("div.errorContainer");
        errorContainer.hide();

        var submitButton = container.find("button.submit");
        submitButton.click(function() {
            var inputEditor = tryml.editors[editorId];
            $.ajax({
                url: "/exec.xqy",
                type: "POST",
                data: { code: inputEditor.getCode() },
                success: function(json) {
                    var data = JSON.parse(json);
                    if(data.results !== undefined) {
                        if(outputType === "html") {
                            outputContainer.html(data.results);
                        }
                        else {
                            outputEditor.setCode(data.results);
                        }
                        outputContainer.slideDown();
                        errorContainer.slideUp();
                    }
                    else {
                        errorContainer.slideDown();
                        outputContainer.slideUp();
                        errorContainer.html(data.error.message);

                        var line = inputEditor.nthLine(data.error.line);
                        var length = inputEditor.lineContent(line).length;
                        inputEditor.selectLines(line, 0, line, length);
                    }
                },
                statusCode: {
                    500: function(jqXHR, textStatus, errorThrown) {
                        errorContainer.slideDown();
                        outputContainer.slideUp();
                        errorContainer.html(jqXHR.responseText);
                    }
                }
            });
        });

        return container;
    }
    else {
        return $(block).replaceWithReturningNew("<div class='codeContainer'><div class='inputContainer'></div></div>");
    }
};

tryml.renderBlock = function(block) {
    var config = tryml.blockToParserConfig($(block), "input");
    config.content = block.value;

    var editorId = block.id;
    if(editorId === undefined) {
        editorId = "editor-" + Math.random(999999999999999999);
    }
    var container = tryml.setupDOM($(block), editorId);

    tryml.editors[editorId] = new CodeMirror(container.find("div.inputContainer").get(0), config);

    // var editor = CodeMirror.fromTextArea(block, config);
};

$(document).ready(function() {
    $("textarea.code").each(function(index, block) {
        tryml.renderBlock(block);
    });
    $("a.goToLine").click(function() {
        var classes = $(this).attr('class').split(/\s+/);
        $.each(classes, function(index, className) {
            var bits = className.split("-");
            var editor = tryml.editors[bits[0]];
            var startLineNumber = parseInt(bits[1], 10);
            var endLineNumber = parseInt(bits[2], 10);
            if(editor !== undefined && startLineNumber > 0 && endLineNumber > 0) {
                var length = editor.lineContent(editor.nthLine(endLineNumber)).length;
                editor.selectLines(editor.nthLine(startLineNumber), 0, editor.nthLine(endLineNumber), length);
            }
            else if(editor !== undefined && startLineNumber > 0) {
                var length = editor.lineContent(editor.nthLine(startLineNumber)).length;
                editor.selectLines(editor.nthLine(startLineNumber), 0, editor.nthLine(startLineNumber), length);
            }
        });
    });
});
