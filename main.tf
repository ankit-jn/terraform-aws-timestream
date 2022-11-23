resource aws_timestreamwrite_database "this" {
    count = var.create_database ? 1 : 0
  
    database_name = var.database_name
    kms_key_id    = local.kms_key_arn

    tags = merge( { "Name" = var.database_name }, var.default_tags )
}

resource aws_timestreamwrite_table "this" {
    for_each = { for table in var.tables: table.name => table }

    database_name = var.database_name
    table_name = each.key

    ## Data retention
    retention_properties {
        magnetic_store_retention_period_in_days = try(each.value.magnetic_store_retention_period, 73000)
        memory_store_retention_period_in_hours  = try(each.value.memory_store_retention_period, 6)
    }

    ## Magnetic Storage Writes
    dynamic "magnetic_store_write_properties" {
        for_each = try(each.value.enable_magnetic_store_writes, false) ? [1] : []

        content {
            enable_magnetic_store_writes = true

            dynamic "magnetic_store_rejected_data_location" {
                for_each = try(each.value.error_log_location.bucket_name, "") == "" ? [] : [1] 

                content {
                    s3_configuration {
                        bucket_name = each.value.error_log_location.bucket_name
                        encryption_option = try(each.value.error_log_location.encryption_option, null)
                        kms_key_id = try(each.value.error_log_location.kms_key_id, null)
                        object_key_prefix = try(each.value.error_log_location.object_key_prefix, null)
                    }
                }
            }
        }
    }

    tags = merge( { "Name" = each.value.name }, 
                    { "Database" = var.database_name }, 
                    try(each.value.tags, {}),
                    var.default_tags )

    depends_on = [
      aws_timestreamwrite_database.this
    ]
}