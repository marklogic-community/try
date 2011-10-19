if(typeof tryml == "undefined" || !tryml) {
    tryml = {};
}

tryml.editors = {};
tryml.hostedDomain = undefined;

tryml.blockToParserConfig = function(block, type) {
    var config = {
        lineNumbers: true,
        readOnly: false
        /* height: "dynamic", */
        /* minHeight: 70 */
    };

    if(type === "output") {
        config.reindentOnLoad = true;
    }

    if(block.hasClass("readonly") || type === "output") {
        config.readOnly = true;
    }

    if(block.hasClass(type + "-xquery")) {
        config.mode = "xquery";
        // config.theme = "xquery-dark";
    }
    else if(block.hasClass(type + "-xml") || block.hasClass(type + "-html")) {
        config.mode = "xml";
    }
    else if(block.hasClass(type + "-json")) {
        config.mode = {"name": "javascript", "json": true};
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
        var outputEditor = undefined;
		var outputConfig = tryml.blockToParserConfig(block, "output");

        var newStructure;
        if(outputType !== "html") {
            newStructure = "<div id='" + editorId + "' class='codeContainer'><div class='inputContainer'></div><div class='code_go'><a class='submit btn btn_blue'>Run</a></div><div class='outputContainer'></div><div class='errorContainer'></div></div>";
        }
        else {
            newStructure = "<div id='" + editorId + "' class='codeContainer'><div class='inputContainer'></div><div class='code_go'><a class='submit btn btn_blue'>Run</a><div class='switch'><a class='rendered active' href='#'>HTML</a><a class='source' href='#'>Source</a></div></div><div class='outputContainer'><div class='rendered'></div><div class='source'></div></div><div class='errorContainer'></div></div>";
        }

        var container = block.replaceWithReturningNew(newStructure);

        var outputContainer = container.find("div.outputContainer");
        outputContainer.hide();
        outputContainer.addClass(outputType);

        if(outputType !== "html") {
            outputEditor = CodeMirror(outputContainer.get(0), outputConfig);
        }
        else {
            outputEditor = CodeMirror(outputContainer.find("div.source").get(0), outputConfig);
        }

        var errorContainer = container.find("div.errorContainer");
        errorContainer.hide();

		var updateHTMLOutput = function() {
			if(container.find("div.switch a.rendered").hasClass("active")) {
				container.find("div.rendered").show();
				container.find("div.source").hide();
			}
			if(container.find("div.switch a.source").hasClass("active")) {
				container.find("div.rendered").hide();
				container.find("div.source").show();
			}
			outputEditor.refresh();
		};

		container.find("div.switch a").click(function() {
			container.find("div.switch a").removeClass("active");
			$(this).addClass("active");
			updateHTMLOutput.call();
		});

        var submitButton = container.find("a.submit");
        submitButton.click(function() {
            if(submitButton.hasClass("disabled")) {
                return;
            }

			if(outputType === "html") {
				updateHTMLOutput.call();
			}

			updateHTMLOutput.call();

			container.find("div.switch").show();

            submitButton.addClass("disabled");

            var inputContainer = $(container.find("div.inputContainer").get(0));
            var loading = $("<div class='loadingoverlay'><&nbsp;</div>");
            inputContainer.prepend(loading);
            loading.height(inputContainer.height());

            var inputEditor = tryml.editors[editorId];
            $.ajax({
                url: tryml.hostedDomain + "/exec.xqy",
                data: { code: inputEditor.getValue() },
                dataType: "jsonp",
                success: function(json) {
                    submitButton.removeClass("disabled");
                    loading.remove();
                    if(json.results !== undefined) {
                        if(outputType === "html") {
                            outputContainer.find("div.rendered").html(json.results);
                        }
                        if(outputConfig.mode.name !== undefined && outputConfig.mode.name === "javascript" && outputConfig.mode.json === true) {
                            outputEditor.setValue(JSON.stringify(JSON.parse(json.results), undefined, 2));
                        }
                        else {
                            outputEditor.setValue(json.results);
                        }

                        outputContainer.slideDown(undefined, function() {
                            outputEditor.refresh();
                        });
                        errorContainer.slideUp();
                    }
                    else {
                        errorContainer.slideDown();
                        outputContainer.slideUp();
                        errorContainer.html(json.error.message);

                        var lineNumber = parseInt(json.error.line, 10) - 1;
                        var line = inputEditor.getLine(lineNumber);
                        inputEditor.setSelection({"line": lineNumber, "ch": 0}, {"line": lineNumber, "ch": line.length});
                    }
                },
                error: function() {
                    submitButton.removeClass("disabled");
                    loading.remove();
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
        return block.replaceWithReturningNew("<div id='" + editorId + "' class='codeContainer'><div class='inputContainer readonly'></div></div>");
    }
};

tryml.renderBlock = function(block) {
    var config = tryml.blockToParserConfig($(block), "input");
    config.value = block.value;

    var editorId = block.id;
    if(editorId === undefined) {
        editorId = "editor-" + Math.random(999999999999999999);
    }
    var container = tryml.setupDOM($(block), editorId);

    tryml.editors[editorId] = CodeMirror(container.find("div.inputContainer").get(0), config);
};

$(document).ready(function() {
    var scriptTags = $("script");

    scriptTags.each(function(index, script) {
        var src = "" + script.getAttribute("src");
        if(src.match("js/tryml.js$")) {
            tryml.hostedDomain = src.split("/").slice(0, 3).join("/");
        }
    });

    $.fn.replaceWithReturningNew = function () {
        var ret = $(arguments[0]);
        this.replaceWith(ret);
        return ret;
    };

    $("textarea.trymlcode").each(function(index, block) {
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
                var length = editor.getLine(endLineNumber - 1).length;
                editor.setSelection({"line": startLineNumber - 1, "ch": 0}, {"line": endLineNumber - 1, "ch": length});
            }
            else if(editor !== undefined && startLineNumber > 0) {
                var length = editor.getLine(startLineNumber - 1).length;
                editor.setSelection({"line": startLineNumber - 1, "ch": 0}, {"line": startLineNumber - 1, "ch": length});
            }
        });
    });
});
