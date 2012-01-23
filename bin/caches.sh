#! /bin/sh
usage(){
	echo "*************************************************************"
	echo "* caches [cat|catver|pub|user|order|site] [port] [host]     *"
	echo "* defaults to 8080 localhost                                *"
	echo "*************************************************************"
}
invalidate(){
    curl -u admin:admin -d "invokeMethod=${method}" -d submit="Invoke+Method" "http://${host}:${port}/dyn/admin/nucleus$1"
}
host=$3
port=$2
component=$1
method="invalidateCaches"
if [ "${host}x" = "x" ]; then
	host="localhost"
fi
if [ "${port}x" = "x" ]; then
	port="8080"
fi
if [ "${component}x" = "x" ]; then
	usage
	exit 1
fi
case ${component} in 
    cat)    repo="/atg/commerce/catalog/ProductCatalog/"
;;
esac
case ${component} in 
    catver)    repo="/atg/commerce/catalog/ProductCatalog-ver/"
;;
esac
case ${component} in 
    price)   repo="/atg/commerce/pricing/priceLists/PriceLists/"
;;
esac
case ${component} in 
    pricever)    repo="/atg/commerce/pricing/priceLists/PriceLists-ver/"
;;
esac
case ${component} in 
    site)    repo="/atg/multisite/SiteRepository/"
;;
esac
case ${component} in 
    sitever)    repo="/atg/multisite/SiteRepository-ver/"
;;
esac
case ${component} in
    pub) repo="/atg/epub/PublishingRepository/"
;;
esac
case ${component} in
    user) repo="/atg/userprofiling/ProfileAdapterRepository/"
;;
esac
case ${component} in
    order) repo="/atg/commerce/order/OrderRepository/"
;;
esac
invalidate ${repo}
exit 0
