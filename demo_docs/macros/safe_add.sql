{% macro safe_add(field_list) %}
{% set fields = [] %}

{% for field in field_list %}
{% do fields.append("COALESCE(" ~ field ~ ", 0)") %}

{% if not loop.last %} , {% endif %}
{% endfor %}

{{fields | join(' + ')}}
{% endmacro %}

 