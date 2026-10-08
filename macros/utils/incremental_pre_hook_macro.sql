{% macro incremental_pre_hook_macro(statement) %}

    {% if is_incremental() %}
        {{ log("------ Incremental Load -------")  }}
        {{ return(render(statement)) }}

    {% else %}
        {{ log("------ Initial Load -------")  }}
        {{ return('select 1') }}
    {% endif %}


{% endmacro %}
