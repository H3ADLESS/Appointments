package appointments

class DropdownTagLib {
    /**
     * Needed arguments:
     *  - id: html id
     *  - callback: javascript callback to execute on select
     *  - name
     *  - domain: Domain object with id and toString()
     * @return
     */
    def dropdown = { attrs, body ->

        String id = attrs.id
        String callback = attrs.callback
        String name = attrs.name
        List<Object> domain = attrs.options
        Map<String, String> defaultOption = attrs.defaultOption
        String nameField = attrs.nameField
        Object selected = attrs.selected

        String options = ""
        if (defaultOption != null) {
            options = options + '<li class="dropdown-option" data-id="' + defaultOption.entrySet().first().key + '">' + defaultOption.entrySet().first().value + '</li>'
        }

        if (domain != null) {
            for (Object o in domain){
                String selectionStatus = "";
                if (selected != null && o.id == selected.id) {
                    selectionStatus = "selected"
                }

                if (!nameField) {
                    options += '\n<li class="dropdown-option ' + selectionStatus + '" data-id="' + o.id + '">' + o.toString() + '</li>'
                } else {
                    options += '\n<li class="dropdown-option ' + selectionStatus + '" data-id="' + o.id + '">' + o."${nameField}" + '</li>'
                }
            }
        }

        String nameLine = '      <span class="dropdown-text">'+ name +'</span>\n'
        if (selected) {
            if (!nameField) {
                nameLine = '      <span class="dropdown-text">' + selected.toString() + '</span>\n'
            } else {
                nameLine = '      <span class="dropdown-text dropdown-option-selected">' + selected."${nameField}" + '</span>\n'
            }
        }

        out <<
         '<div class="dropdown-textfield">\n'+
        '   <div id="'+ id +'" class="dropdown" type="text">\n'+
        nameLine +
        '           <div style="float: right">\n'+
        '               <i style="color: black" class="material-icons">arrow_drop_down</i>\n'+
        '           </div>\n'+
        '           <ul class="dropdown-options-container">\n' +
        options +
        '           </ul>\n'+
        '       </div>\n'+
        '   </div>\n'+
        '   <script>\n'+
        '       $(document).ready(function () {\n'+
        '           (function () {\n'+
        '               var filterInput = $("#'+ id +'");\n'+
        '               var dropdownText = filterInput.children(".dropdown-text");\n'+
        '               var optionContainer = filterInput.children(".dropdown-options-container");\n'+
        '               var options = optionContainer.children(".dropdown-option");\n'+
        '\n'+
        '               filterInput.on("click", function (event) {\n'+
        '                   optionContainer.slideToggle();\n'+
        '                   event.stopPropagation();\n'+
        '               });\n'+
        '\n'+
        '               $("html").on("click", function () {\n'+
        '                   if (optionContainer.is(":visible")){\n'+
        '                       optionContainer.slideToggle();\n'+
        '                   }\n'+
        '               });\n'+
        '\n'+
        '               options.on("click", function () {\n'+
        '                   var text = $(this).text();\n'+
        '                   var id = $(this).data("id");\n'+
        '                   if (id !== 0){\n'+
        '                       dropdownText.text(text);\n'+
        '                       dropdownText.css("color", "black");\n'+
        '                       options.removeClass("selected");\n'+
        '                       $(this).addClass("selected");\n'+
        '                       '+ callback +';\n'+
        '                   } else {\n'+
        '                       options.removeClass("selected");\n'+
        '                       $(this).addClass("selected");\n'+
        '                       dropdownText.text(text);\n'+
        '                       dropdownText.css("color", "");\n'+
        '                       '+ callback +'();\n'+
        '                   }\n'+
        '               })\n'+
        '           })();\n'+
        '       })\n'+
        '   </script>\n'


    }

}
