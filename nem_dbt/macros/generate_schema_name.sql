{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if target.type == 'databricks' and custom_schema_name == 'staging' -%}
        silver
    {%- elif target.type == 'databricks' and custom_schema_name == 'marts' -%}
        gold
    {%- elif custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ target.schema }}_{{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}