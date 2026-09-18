FROM node:22-slim

ARG user=develop
ARG uid=1000

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN existing_user="$(getent passwd "${uid}" | cut -d: -f1)" \
    && if [ -z "${existing_user}" ]; then \
         useradd -G www-data,root -u "${uid}" -d "/home/${user}" -m "${user}"; \
       elif [ "${existing_user}" != "${user}" ]; then \
         usermod -l "${user}" "${existing_user}" \
         && usermod -d "/home/${user}" -m "${user}" \
         && groupmod -n "${user}" "${existing_user}"; \
       fi

RUN npm install -g @fission-ai/openspec@latest \
    && chown -R ${uid}:${uid} /usr/local/lib/node_modules /usr/local/bin

WORKDIR /var/www/html

COPY .docker/addons/app/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

USER ${uid}

ENTRYPOINT ["entrypoint.sh"]
