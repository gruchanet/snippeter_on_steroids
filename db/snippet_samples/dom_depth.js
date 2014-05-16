var documentRoot = $(document.documentElement); // $('html')

$(document).ready(function() {
    console.log(treeDepth(documentRoot, {elem: documentRoot, depth: 0}));
});

function treeDepth(elem, current) {
    var deepestElem = current;

    $(elem).each(function() {
        var elemContents = this.children;

        if (elemContents) {
            for (var i = 0; i < elemContents.length; i++) {
                var tempElem = treeDepth(elemContents[i], {elem: elemContents[i], depth: current.depth + 1});

                if (tempElem.depth > deepestElem.depth) {
                    deepestElem = tempElem;
                }
            }
        }
    })

    return deepestElem;
}