env_vars=$(env)
var_string=""
for env in $env_vars; do
  var_string+=" -e "
  var_string+=$env
done
export PARAMS=${var_string}
echo $PARAMS