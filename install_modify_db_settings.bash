REPET_PREFIX=/tmp/global2/ibezrukov2/conda/envs/repet3/REPET/REPET_linux-x64-3.0/

sed  -i 's|chr", "varchar(255|chr", "varchar(50|g' ${REPET_PREFIX}/commons/core/sql/DbMySql.py
sed  -i 's|name", "varchar(255|name", "varchar(50|g' ${REPET_PREFIX}/commons/core/sql/DbMySql.py
sed  -i 's|accession", "varchar(255|accession", "varchar(100|g' ${REPET_PREFIX}/commons/core/sql/DbMySql.py
sed  -i 's|description", "varchar(255|description", "varchar(100|g' ${REPET_PREFIX}/commons/core/sql/DbMySql.py
sed  -i 's|jobname", "varchar(255|jobname", "varchar(100|g' ${REPET_PREFIX}/commons/core/sql/DbMySql.py
sed  -i 's|status", "varchar(255|status", "varchar(100|g' ${REPET_PREFIX}/commons/core/sql/DbMySql.py
sed  -i 's|class_classif", "varchar(255|class_classif", "varchar(100|g' ${REPET_PREFIX}/commons/core/sql/DbMySql.py
sed  -i 's|order_classif", "varchar(255|order_classif", "varchar(100|g' ${REPET_PREFIX}/commons/core/sql/DbMySql.py
sed  -i 's|completeness", "varchar(255|completeness", "varchar(100|g' ${REPET_PREFIX}/commons/core/sql/DbMySql.py
sed  -i 's|contig varchar(255|contig varchar(100|g' ${REPET_PREFIX}/commons/core/sql/DbMySql.py
sed -i '436 s/^/#/' ${REPET_PREFIX}/commons/core/sql/DbMySql.py
