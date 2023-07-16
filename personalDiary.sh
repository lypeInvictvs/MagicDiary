#!/bin/bash


@author: Felype Invictus <felype.invictus@gmail.com>
@version: 1.0


# BLOCO 1
year=$(date +"%Y")
directories=($(find . -maxdepth 1 -type d -name "[0-9]*" -printf "%f\n" | sort -rn))
num_dirs=${#directories[@]}

if [[ $num_dirs -gt 0 ]]; then
  echo "Diretórios disponíveis:"
  for ((i=0; i<$num_dirs; i++)); do
    echo "$(($i+1)). ${directories[$i]}"
  done

  read -p "Digite o número do diretório que deseja acessar: " dir_choice
  selected_dir=${directories[$(($dir_choice-1))]}
  case $dir_choice in
    1)
      echo "Você escolheu $selected_dir"
			
      ;;
    *)
      echo "Escolha inválida"
      exit 1
      ;;
  esac
else
  selected_dir=$year
  mkdir $selected_dir
  echo "Diretório criado: $selected_dir"
fi

cd $selected_dir

# BLOCO 2
subdirectories=($(find . -maxdepth 1 -type d -name "[A-Z]*" -printf "%f\n" | sort))
num_subdirs=${#subdirectories[@]}

if [[ $num_subdirs -gt 0 ]]; then
  echo "Subdiretórios disponíveis:"
  for ((i=0; i<$num_subdirs; i++)); do
    echo "$(($i+1)). ${subdirectories[$i]}"
  done

  read -p "Digite o número do subdiretório que deseja acessar: " subdir_choice
  selected_subdir=${subdirectories[$(($subdir_choice-1))]}

  case $subdir_choice in
    1)
      echo "Você escolheu $selected_subdir"
      ;;
    *)
      echo "Escolha inválida"
      exit 1
      ;;
  esac
fi


# BLOCO 3
txt_files=($(find . -maxdepth 1 -type f -name "*.txt" -printf "%f\n" | sort))
num_files=${#txt_files[@]}

if [[ $num_files -gt 0 ]]; then
  echo "Lista de arquivos de texto:"
  for ((i=0; i<$num_files; i++)); do
    echo "$(($i+1)). ${txt_files[$i]}"
  done

  read -p "Selecione o arquivo que deseja editar (ou N para sair): " file_choice
  if [[ $file_choice =~ ^[0-9]+$ ]]; then
    selected_file=${txt_files[$(($file_choice-1))]}
    echo "Você escolheu editar $selected_file"
		nvim $selected_file
  elif [[ $file_choice =~ ^[Nn]$ ]]; then
    
read -p "Criar novo arquivo? (S/N): " create_choice
if [[ $create_choice =~ ^[Ss]$ ]]; then
 nvim 
fi
  else
    echo "Escolha inválida"
    exit 1
  fi
fi


