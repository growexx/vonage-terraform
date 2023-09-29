SRCDIR=src/application/dr_dag_ntw_gw_calls
DEPLOY=deploy
PYTHON=3.11

clean:	
	rm -rf ${DEPLOY}

.venv:
	python${PYTHON} -m venv .venv

deps-build-dr_dag_ntw_gw_calls:    .venv
	. .venv/bin/activate && pip install -U -r ${SRCDIR}/helpers/requirements.txt

build-dr_dag_ntw_gw_calls: clean deps-build-dr_dag_ntw_gw_calls
	install -d ${DEPLOY}
	install -m 755 ${SRCDIR}/lambda_function.py ${DEPLOY}/
	install -m 755 ${SRCDIR}/template.sql ${DEPLOY}/
	install -m 755 ${SRCDIR}/helpers/snf_db.py ${DEPLOY}/
	install -m 755 ${SRCDIR}/helpers/get_secret.py ${DEPLOY}/
	cp -a .venv/lib/python${PYTHON}/site-packages/. ${DEPLOY}/
	cp -a .venv/lib64/python${PYTHON}/site-packages/. ${DEPLOY}/
	cd ${DEPLOY} && zip -r -q ./dr_dag_ntw_gw_calls.zip . && aws s3 cp dr_dag_ntw_gw_calls.zip s3://edw-data-residency-test/dag_ntw_gw_calls/
	