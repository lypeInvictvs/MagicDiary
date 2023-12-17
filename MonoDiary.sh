#!/bin/bash

#@author: Felype Invictus <felype.invictus@gmail.com>
#@version: 1.0



nomeMes (){
  echo "$(date +"%d_%b" | tr '[:lower:]' '[:upper:]')"
}







year=$(date +"%Y")
month_dir=$(date +%B | tr '[:lower:]' '[:upper:]')
directories=($(find . -maxdepth 1 -type d -name "[0-9]*" -printf "%f\n" | sort -rn))
num_dirs=${#directories[@]}

if [[ $num_dirs -gt 0 ]]; then
  echo "Diretórios disponíveis:"
  for ((i=0; i<$num_dirs; i++)); do
    echo "$(($i+1)). ${directories[$i]}"
  done

  read -p "Digite o número do diretório que deseja acessar: " dir_choice
  selected_dir=${directories[$(($dir_choice-1))]}

  if [[ -d $selected_dir ]]; then
    echo "Você escolheu $selected_dir"
    cd $selected_dir

    

    if [[ -d "$month_dir" ]]; then
      echo "A '$month_dir' já existe"

      subdirectories=($(find . -maxdepth 1 -type d -name "[A-Z]*" -printf "%f\n" | sort))
      num_subdirs=${#subdirectories[@]}

      if [[ $num_subdirs -gt 0 ]]; then
        echo "Subdiretórios disponíveis:"
        for ((i=0; i<$num_subdirs; i++)); do
          echo "$(($i+1)). ${subdirectories[$i]}"
        done

        read -p "Digite o número que corresponde ao mês: " subdir_choice
        selected_subdir=${subdirectories[$(($subdir_choice-1))]}

        echo "Você escolheu $selected_subdir"
        cd $selected_subdir

        num_files=$(ls *.txt 2> /dev/null | wc -l)

        if [[ "$num_files" -gt 0 ]]
        then
          txt_files=($(find . -maxdepth 1 -type f -name "*.txt" -printf "%f\n" | sort))
          num_files=${#txt_files[@]}

          echo "lista de arquivos de texto:"
          for ((i=0; i<$num_files; i++)); do
            echo "$(($i+1)). ${txt_files[$i]}"
          done

          read -p "selecione o arquivo que deseja editar ( OU DIGITE 'C' - PARA CRIAR UM ARQUIVO NOVO): " file_choice
          if [[ $file_choice =~ ^[0-9]+$ ]]; then
            selected_file=${txt_files[$(($file_choice-1))]}
            echo "você escolheu editar $selected_file"
            nvim $selected_file
          elif [[ $file_choice =~ ^[cC]$ ]]; then
            nome_arquivo=$(date +"%d_%b" | tr '[:lower:]' '[:upper:]').txt
            
            # Compara arquivos já existentes
            for ((i=0; i<$num_files; i++)); do
            echo "$nome_arquivo ${txt_files[$i]}"
             if [[ "$nome_arquivo" == "${txt_files[$i]}" ]]; then
             echo "O arquivo já existe!"
             exit 1
            fi
          done

            echo "$(date +"%d de %b")" > "$nome_arquivo"
            nvim $nome_arquivo
          else
            echo "Escolha inválida"
            exit 1
          fi
        else
          echo "Não há arquivos .txt para editar."
          echo "Será gerado um arquivo agora..."
          sleep 10
          nome_arquivo=$(date +"%d_%b").txt
            echo "$(date +"%d de %b")" > "$nome_arquivo"
            nvim $nome_arquivo
        fi
      else
        echo "Não há subdiretórios disponíveis."
      fi
    else
      mkdir $month_dir
      echo "A pasta $month_dir foi criada."

      #Criar arquivo


    fi
  else
    echo "O diretório selecionado não existe."
    exit 1
  fi
else
  mkdir $year
  echo "Diretório criado: $year"
  cd $year
  mkdir $month_dir
  cd $month_dir

  #$(date +%B | tr '[:lower:]' '[:upper:]')


  nome_arquivo=$(date +"%d_%b" | tr '[:lower:]' '[:upper:]').txt
  
  

  echo "$(date +"%^d de %^b")" > "$nome_arquivo"
  nvim "$nome_arquivo"
fi

