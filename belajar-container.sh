# Mengecek versi Docker
docker version

# Mengecek list image
docker image ls

# Mengunduh image Docker
docker image pull namaimage:tag
docker image pull redis:latest # Contoh

# Menghapus image
docker image rm namaimage:tag
docker image rm redis:latest # Contoh

# Melihat semua list container 
docker container ls -a

# Melihat list container yang aktif 
docker container ls 

# Membuat container 
docker container create --name namacontainer namaimage:tag
docker container create --name contohredis redis:latest # Contoh

# Menjalankan container
docker container start containerId/namacontainer
docker container start contohredis # Contoh

# Menghentikan container
docker container stop containerId/namacontainer
docker container stop contohredis # Contoh

# Menghapus container
docker container rm containerId/namacontainer
docker container rm contohredis # Contoh

# Membaca log
docker container logs containerId/namacontainer
docker container logs contohredis # Contoh

# Membaca log real-time
docker container logs -f containerId/namacontainer
docker container logs -f contohredis # Contoh

# Masuk ke container melalui Container Exec
docker container exec -i -t containerId/namacontainer /bin/bash
docker container exec -i -t contohredis /bin/bash # Contoh

# -i adalah argument interaktif, menjaga input tetap aktif
# -t adalah argument untuk alokasi pseudo-TTY (terminal akses)
# /bin/bash contoh kode program yang terdapat di dalam container

# Port Forwarding
docker container create --name namacontainer --publish posthost:portcontainer image:tag
docker container create --name contohnginx --publish 8080:80 nginx:latest # Contoh or
docker container create --name contohnginx -p 8080:80 nginx:latest # Contoh

# Jika kita ingin melakukan port forwarding lebih dari satu, kita bisa tambahkan dua kali parameter 
# --publish
# --publish juga bisa disingkat menggunakan -p


# Menambahkan environment variable
docker container create --name namacontainer --env KEY=”value” --env KEY2=”value” image:tag
docker container create --name contohmongo -p 27017:27017 --env MONGO_INITDB_ROOT_USERNAME=miftah --env MONGO_INITDB_ROOT_PASSWORD=miftah mongo:latest # Contoh

# Melihat stats
docker container stats

# Resource limit
# --memory (b, k, m, g)
# --cpus 1.5
docker container create --name smallnginx --publish 8081:80 --memory 100m --cpus 0.5 nginx:latest

# Bind Mount
docker container create --name namacontainer --mount “type=bind,source=folder,destination=folder,readonly” image:tag

docker container create --name mongodata -p 27018:27017 --mount "type=bind,source=D:\Development\docker\mongo-data,destination=/data/db" --env MONGO_INITDB_ROOT_USERNAME=miftah --env MONGO_INITDB_ROOT_PASSWORD=miftah mongo:latest # Contoh

# Melihat list volume
docker volume ls

# Membuat volume
docker volume create namavolume
docker volume create mongovolume

# Menghapus volume
docker volume rm namavolume
docker volume rm mongovolume


# Menggunakan volume di container
# Langkah
docker volume create mongodata
docker container create --name mongovolume --mount "type=volume,source=mongodata,destination=/data/db" -p 27020:27017 --env MONGO_INITDB_ROOT_USERNAME=miftah --env MONGO_INITDB_ROOT_PASSWORD=miftah mongo:latest # Contoh


# Backup volume
# Langkah
docker container create --name nginxbackup --mount "type=bind,source=D:\Development\docker\backup,destination=/backup" --mount "type=volume,source=mongodata,destination=/data" nginx:latest
docker container start nginxbackup
docker container exec -i -t nginxbackup /bin/bash
tar cvf /backup/backup.tar.gz /data
docker container stop nginxbackup
docker container rm nginxbackup

# Langkah yang lebih cepat
docker container run --rm --name ubuntu --mount "type=bind,source=D:\Development\docker\backup,destination=/backup" --mount "type=volume,source=mongodata,destination=/data" ubuntu:latest tar cvf /backup/ubuntubackup.tar.gz /data


# Restore volume
docker volume create mongorestore
docker container run --rm --name ubuntu --mount "type=bind,source=D:\Development\docker\backup,destination=/backup" --mount "type=volume,source=mongorestore,destination=/data" ubuntu:latest bash -c "cd /data && tar xvf /backup/backup.tar.gz --strip 1"
docker container create --name mongorestore --mount "type=volume,source=mongorestore,destination=/data/db" -p 27021:27017 --env MONGO_INITDB_ROOT_USERNAME=miftah --env MONGO_INITDB_ROOT_PASSWORD=miftah mongo:latest
docker container start mongorestore

# Membuat network
docker network ls
docker network create --driver namadriver namanetwork  # Jika drive tidak disebut maka defaultnya adalah bridge
docker network rm namanetwork # Tidak bisa dihapus apabila sudah digunakan oleh container

# Menambahkan container ke network
docker network create --driver bridge mongonetwork
docker container create --name mongodb --network mongonetwork --env MONGO_INITDB_ROOT_USERNAME=miftah --env MONGO_INITDB_ROOT_PASSWORD=miftah mongo:latest
docker image pull mongo-express:latest
docker container create --name mongodbexpress --publish 8081:8081 --network mongonetwork --env ME_CONFIG_MONGODB_URL=mongodb://miftah:miftah@mongodb:27017/ mongo-express:latest
docker container start mongodb
docker container start mongodbexpress

# Menghapus container dari network
docker network disconnect mongonetwork mongodb

# Menambahkan container yang sudah dibuat 
docker network connect mongonetwork mongodb

# Inspect 
docker image inspect namaimage:tag 
docker container inspect namacontainer 
docker volume inspect namavolume 
docker network inspect namanetwork 

# Prune
# Menghapus semua container yang tidak digunakan
docker container prune
# Menghapus semua image yang tidak digunakan
docker image prune
# Menghapus semua network yang tidak digunakan
docker network prune
# Menghapus semua volume yang tidak digunakan
docker volume prune
# Menghapus semua system yang tidak digunakan
docker system prune

