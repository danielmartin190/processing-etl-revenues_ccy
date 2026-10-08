{% macro generate_alias_name(custom_alias_name=none, node=none) -%}

    {%- if custom_alias_name is none -%}

        {% if node.resource_type == 'test' %}

            {{ node.package_name + '__' + node.name.lower() }}

        {% else %}

            {{ node.name }}
        
        {%- endif -%}

    {%- else -%}

        {% if node.resource_type == 'test' %}

            {{ node.package_name + '__' + custom_alias_name.lower() }}

        {% else %}

            {{ custom_alias_name | trim }}

        {%- endif -%}

    {%- endif -%}

{%- endmacro %}
