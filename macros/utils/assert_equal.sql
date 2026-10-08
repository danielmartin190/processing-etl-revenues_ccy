{% macro assert_equal(expected, actual, columns) %}
    {% if not columns %}
        {% set columns = ['*'] %}
    {% endif %}

    -- noqa: disable=L036
    with
    expected_not_found as (
        with
            expected_except as (
                select
                    {{ columns | join(', ') }}
                from {{ expected }}
                except
                select
                    {{ columns | join(', ') }}
                from {{ actual }}
            )

            select
                'expected' as row_type,
                *
            from expected_except
    ),

    actual_not_found as (
        with
            actual_except as (
                select
                    {{ columns | join(', ') }}
                from {{ actual }}
                except
                select
                    {{ columns | join(', ') }}
                from {{ expected }}
            )

            select
                'actual' as row_type,
                *
            from actual_except
    )

    select
        *
    from expected_not_found
    union all
    select
        *
    from actual_not_found
{% endmacro %}
