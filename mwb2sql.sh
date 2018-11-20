# generate sql from mwb
# usage: sh mwb2sql.sh {mwb file} {output file}
# prepare: set env MYSQL_WORKBENCH
#
# options
#   GenerateDrops             Generate DROP Statements Before Each CREATE Statement
#   GenerateSchemaDrops       Generate DROP SHEMA
#   SortTablesAlphabetically  Sort Tables Alphabetically
#   SkipForeignKeys           Skip Creation of FOREIN KEYS
#   SkipFKIndexes             Skip creation of FK Indexes as well
#   OmitSchemata              Omit Schema Qualifier in Object Names
#   GenerateUse               Generate USE statement
#   GenerateCreateIndex       Generate Separate CREATE INDEX Statement
#   GenerateWarnings          Add SHOW WARNNINGS After Every DDL Statement
#   NoUsersJustPrivileges     Do Not Create Users. Only Export Privileges
#   NoViewPlaceholders        Don't create view placeholder tables.
#   GenerateInserts           Generate INSERT Statements for Tables
#   NoFKForInserts            Disable FK Checks for inserts
#   TriggersAfterInserts      Create triggers after inserts

if [ "$MYSQL_WORKBENCH" = "" ]; then
  export MYSQL_WORKBENCH="/Applications/MySQLWorkbench.app/Contents/MacOS/MySQLWorkbench"
fi

export INPUT=$(cd $(dirname $1);pwd)/$(basename $1)
export OUTPUT=$(cd $(dirname $2);pwd)/$(basename $2)

"$MYSQL_WORKBENCH" \
  --model $INPUT \
  --run-python "
import os
import grt
from grt.modules import DbMySQLFE as fe
c = grt.root.wb.doc.physicalModels[0].catalog
options = {
    'GenerateDrops': 1,
    'GenerateSchemaDrops': 1,
    'OmitSchemata': 1,
    'GenerateUse': 1
}
fe.generateSQLCreateStatements(c, c.version, options)
fe.createScriptForCatalogObjects(os.getenv('OUTPUT'), c, options)" \
  --quit-when-done

