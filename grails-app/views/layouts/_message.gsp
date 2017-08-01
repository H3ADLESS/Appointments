<g:if test="${flash.error}">
    <div style="clear: both; content: ' ">
    <div class="flash error">
        <i class="material-icons">error</i>
        <span class="message">${flash.error}</span>
    </div>
    <div style="clear: both; content: ' ">
</g:if>
<g:if test="${flash.message}">
    <div style="clear: both; content: ' ">
        <div class="flash message">
            <i class="material-icons">info</i>
            <div class="message" style="display: block">${flash.message}</div>
        </div>
    <div style="clear: both; content: ' ">
</g:if>
