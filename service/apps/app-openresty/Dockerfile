FROM openresty/openresty:bullseye-fat
RUN opm get ledgetech/lua-resty-http
ADD conf.d/app.conf /etc/nginx/conf.d/app.conf
ADD conf.d/hello.lua /etc/nginx/conf.d/hello.lua
CMD ["/usr/bin/openresty", "-g", "daemon off;"]
