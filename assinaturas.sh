#!/bin/bash -x

if [ $# == 0 ]; then
 echo "(i) Iniciar, (a) Alice, (b) Bob  (1) Badboy ataque 1 (2) Badboy ataque 2"
 exit
fi
dir=$HOME/crypto4

if [ $1 == 'i' ]; then
  echo  "Inicializa as pastas representando Alice, Bob e Badboy"
  exit
elif [ $1 == 'a' ]; then
  echo "Alice gera as chaves pública e privada"
  echo "Alice assina a mensagem com a chave privada"  
  echo "Alice envia a mensagem e a assinatura para Bob"
  exit
elif [ $1 == 'b' ]; then
  echo "Bob verifica a mensagem de Alice usando a chave pública"
  exit
elif [ $1 == '1' ]; then
  echo "Badboy (man-in-the-middle) intercepta a assinatura enviada por Alice"
  echo "Badboy envia uma mensagem falsa para Bob com a assinatura de Alice"  
  exit
elif [ $1 == '2' ]; then
  echo "Badboy gera a chave privada"
  echo "Badboy gera uma mensagem falsa para Bob assinada com sua chave privada"  
  echo "Badboy envia a mensagem falsa com sua assinatura para Bob dizendo-se Alice"
  exit
fi

exit
--------------------------------------------------------------------------------------------
# Inicialização:
 rm -R -f crypto4
 mkdir crypto4
 cd crypto4
 mkdir alice
 mkdir bob
 mkdir badboy
 --------------------------------------------------------------------------------------------
# Ações da Alice:
 cd $dir/alice
 openssl genrsa -out alice_key.pem 1024
 openssl rsa -in alice_key.pem -pubout -out alice_pubkey.pem
 echo "Mensagem de Alice" > alice.txt
 openssl dgst -sha1 -sign alice_key.pem -out alice.sign alice.txt
 cp alice_pubkey.pem $dir/bob
 cp alice.txt $dir/bob
 cp alice.sign $dir/bob
--------------------------------------------------------------------------------------------
# Ações do Bob:
 cd $dir/bob
 openssl dgst -sha1 -verify alice_pubkey.pem -signature alice.sign alice.txt
--------------------------------------------------------------------------------------------
# Ações do Badboy (Ataque 1):
 cp $dir/alice/alice.sign $dir/badboy
 cd $dir/badboy
 echo "Mensagem falsa da Alice" > alice.txt
 cp alice.txt $dir/bob
 cp alice.sign $dir/bob
--------------------------------------------------------------------------------------------
# Ações do Badboy (Ataque 2):
 cd $dir/badboy
 echo "Mensagem falsa da Alice 2" > alice.txt
 openssl genrsa -out badboy_key.pem 1024
 openssl dgst -sha1 -sign badboy_key.pem -out alice.sign alice.txt
 cp alice.txt $dir/bob
 cp alice.sign $dir/bob
--------------------------------------------------------------------------------------------
