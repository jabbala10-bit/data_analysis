# Data Analysis

This folder contains SQL practice material for data analysis interview preparation and day-to-day analyst workflows.

## Folder Structure

- **basic/** - foundational reporting and aggregation queries
- **intermediate/** - segmentation, funnel, retention, and multi-step analysis scenarios
- **advanced/** - complex business analytics such as attribution, anomaly detection, and reconciliation
- **common/** - reusable SQL building blocks for DDL, DML, DCL, window functions, statistics, performance, and quality checks
- **common/dataset_processing/** - SQL patterns for processing single datasets and combining multiple datasets for analytics
- **common/file_to_sql/** - SQL patterns for loading CSV, TSV, TXT, pipe-delimited, semicolon-delimited, fixed-width, and other tabular file formats into SQL tables

## Coverage Areas

- Sales and revenue reporting
- Customer segmentation and lifecycle tracking
- Funnel and conversion analysis
- Retention and repeat behavior analysis
- Data quality profiling and anomaly detection
- Multi-system reconciliation and balance checks
- Business performance and operational reporting
- Payment failure and operational risk analysis
- Inventory and supply chain monitoring
- Marketing ROI and experimentation analysis

## Scenario Files Added

- Basic: [data_analysis/basic/04_top_customers_by_month.sql](data_analysis/basic/04_top_customers_by_month.sql), [data_analysis/basic/05_payment_failure_summary.sql](data_analysis/basic/05_payment_failure_summary.sql), [data_analysis/basic/06_inventory_low_stock_alert.sql](data_analysis/basic/06_inventory_low_stock_alert.sql), [data_analysis/basic/07_sales_by_channel.sql](data_analysis/basic/07_sales_by_channel.sql), [data_analysis/basic/08_employee_performance_summary.sql](data_analysis/basic/08_employee_performance_summary.sql)
- Intermediate: [data_analysis/intermediate/04_campaign_roi.sql](data_analysis/intermediate/04_campaign_roi.sql), [data_analysis/intermediate/05_product_mix_analysis.sql](data_analysis/intermediate/05_product_mix_analysis.sql), [data_analysis/intermediate/06_refund_rate_analysis.sql](data_analysis/intermediate/06_refund_rate_analysis.sql), [data_analysis/intermediate/07_repeat_purchase_frequency.sql](data_analysis/intermediate/07_repeat_purchase_frequency.sql), [data_analysis/intermediate/08_demand_forecast_signal.sql](data_analysis/intermediate/08_demand_forecast_signal.sql)
- Advanced: [data_analysis/advanced/04_customer_lifetime_value.sql](data_analysis/advanced/04_customer_lifetime_value.sql), [data_analysis/advanced/05_churn_risk_segmentation.sql](data_analysis/advanced/05_churn_risk_segmentation.sql), [data_analysis/advanced/06_supplier_performance.sql](data_analysis/advanced/06_supplier_performance.sql), [data_analysis/advanced/07_marketing_lift_analysis.sql](data_analysis/advanced/07_marketing_lift_analysis.sql)
- Common: [data_analysis/common/01_ddl_schema_setup.sql](data_analysis/common/01_ddl_schema_setup.sql), [data_analysis/common/02_dml_data_load_and_updates.sql](data_analysis/common/02_dml_data_load_and_updates.sql), [data_analysis/common/03_dcl_permissions_and_security.sql](data_analysis/common/03_dcl_permissions_and_security.sql), [data_analysis/common/04_window_functions_core.sql](data_analysis/common/04_window_functions_core.sql), [data_analysis/common/05_statistics_descriptive.sql](data_analysis/common/05_statistics_descriptive.sql), [data_analysis/common/06_cte_analytics_pipeline.sql](data_analysis/common/06_cte_analytics_pipeline.sql), [data_analysis/common/07_case_when_business_logic.sql](data_analysis/common/07_case_when_business_logic.sql), [data_analysis/common/08_data_quality_checks.sql](data_analysis/common/08_data_quality_checks.sql), [data_analysis/common/09_joins_for_reporting.sql](data_analysis/common/09_joins_for_reporting.sql), [data_analysis/common/10_performance_tuning_patterns.sql](data_analysis/common/10_performance_tuning_patterns.sql)
- Dataset processing: [data_analysis/common/dataset_processing/single_file/01_single_table_profile.sql](data_analysis/common/dataset_processing/single_file/01_single_table_profile.sql), [data_analysis/common/dataset_processing/single_file/02_single_file_cleaning.sql](data_analysis/common/dataset_processing/single_file/02_single_file_cleaning.sql), [data_analysis/common/dataset_processing/single_file/03_single_file_segment_summary.sql](data_analysis/common/dataset_processing/single_file/03_single_file_segment_summary.sql), [data_analysis/common/dataset_processing/single_file/04_single_file_time_series.sql](data_analysis/common/dataset_processing/single_file/04_single_file_time_series.sql), [data_analysis/common/dataset_processing/single_file/05_single_file_outlier_check.sql](data_analysis/common/dataset_processing/single_file/05_single_file_outlier_check.sql), [data_analysis/common/dataset_processing/multiple_files/01_union_multiple_datasets.sql](data_analysis/common/dataset_processing/multiple_files/01_union_multiple_datasets.sql), [data_analysis/common/dataset_processing/multiple_files/02_consolidate_monthly_files.sql](data_analysis/common/dataset_processing/multiple_files/02_consolidate_monthly_files.sql), [data_analysis/common/dataset_processing/multiple_files/03_compare_datasets.sql](data_analysis/common/dataset_processing/multiple_files/03_compare_datasets.sql), [data_analysis/common/dataset_processing/multiple_files/04_multi_file_join.sql](data_analysis/common/dataset_processing/multiple_files/04_multi_file_join.sql), [data_analysis/common/dataset_processing/multiple_files/05_multi_file_quality_check.sql](data_analysis/common/dataset_processing/multiple_files/05_multi_file_quality_check.sql)
- File to SQL: [data_analysis/common/file_to_sql/01_csv_to_sql_table.sql](data_analysis/common/file_to_sql/01_csv_to_sql_table.sql), [data_analysis/common/file_to_sql/02_tsv_to_sql_table.sql](data_analysis/common/file_to_sql/02_tsv_to_sql_table.sql), [data_analysis/common/file_to_sql/03_txt_to_sql_table.sql](data_analysis/common/file_to_sql/03_txt_to_sql_table.sql), [data_analysis/common/file_to_sql/04_pipe_delimited_to_sql_table.sql](data_analysis/common/file_to_sql/04_pipe_delimited_to_sql_table.sql), [data_analysis/common/file_to_sql/05_semicolon_delimited_to_sql_table.sql](data_analysis/common/file_to_sql/05_semicolon_delimited_to_sql_table.sql), [data_analysis/common/file_to_sql/06_fixed_width_to_sql_table.sql](data_analysis/common/file_to_sql/06_fixed_width_to_sql_table.sql), [data_analysis/common/file_to_sql/07_excel_csv_to_sql_table.sql](data_analysis/common/file_to_sql/07_excel_csv_to_sql_table.sql), [data_analysis/common/file_to_sql/08_json_lines_to_sql_table.sql](data_analysis/common/file_to_sql/08_json_lines_to_sql_table.sql)

## Suggested Study Flow

1. Start with the basic scripts to build comfort with joins, filtering, and aggregation.
2. Move to intermediate scripts for CTEs, segmentation, funnels, and retention logic.
3. Practice advanced scripts for multi-step business metrics and anomaly analysis.

## Notes

These scripts are designed to be portable and can be adapted to PostgreSQL, SQL Server, or other ANSI-style SQL dialects with minor syntax changes.
