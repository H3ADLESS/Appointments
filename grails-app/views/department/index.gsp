<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="mdl-main-layout" />
        <g:set var="entityName" value="${message(code: 'department.label', default: 'Department')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>

    <div class="mdl-grid">
        <div class="mdl-cell mdl-cell--12-col">
            <h5>Fachbereiche</h5>
            <g:render template="/layouts/message"/>
        </div>
    </div>

    <div class="mdl-grid">
        <div class="mdl-cell mdl-cell--12-col">
        <b>Neuen Fachbereich hinzufügen:</b> <br>
        </div>
        <g:form controller="department" action="save">
            <div class="mdl-cell mdl-cell--12-col">
                <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                    <input class="mdl-textfield__input" type="text" id="name" name="name">
                    <label class="mdl-textfield__label" for="name">Name</label>
                </div>
                <br>
                <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                    <input class="mdl-textfield__input" type="text" id="url" name="url">
                    <label class="mdl-textfield__label" for="url">URL</label>
                </div>
                <br>
                <button class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored">
                    Hinzufügen
                </button>
            </div>
        </g:form>
    </div>

    <div class="mdl-grid">
        <div class="mdl-cell mdl-cell--12-col">

            <div class="mdl-cell mdl-cell--12-col" style="overflow-x: auto;">
                <table class="mdl-data-table mdl-js-data-table">
                    <thead>
                    <tr>
                        <th class="mdl-data-table__cell--non-numeric">Name</th>
                        <th class="mdl-data-table__cell--non-numeric">Url</th>
                        <th class="mdl-data-table__cell--non-numeric"></th>
                    </tr>
                    </thead>
                    <tbody>
                        <g:each in="${departmentList.sort()}">
                            <tr>
                                <td class="mdl-data-table__cell--non-numeric">
                                    ${it.name}
                                </td>
                                <td class="mdl-data-table__cell--non-numeric">
                                    ${it.url}
                                </td>
                                <td class="mdl-data-table__cell--non-numeric">
                                    <a href="${createLink(controller: 'department', action: 'delete', id: it.id)}"><i class="material-icons color-green">delete</i> </a>
                                </td>
                            </tr>
                        </g:each>
                    </tbody>
                </table>
            </div>

            <div class="pagination">
                <g:paginate total="${departmentCount ?: 0}" />
            </div>
        </div>
    </div>
    </body>
</html>