#!/bin/bash

#@author: Felype Rangel <felype.invictus@gmail.com>
#@description: A simple script to facilitate the notes in a personal diary through the terminal in Linux.
#@version: 1.5.0



root_dir="/home/$USER/MagicDiary"
createRootDiretory(){
    
    if [[ -d $root_dir ]]; then
        cd $root_dir
    else
        mkdir $root_dir
    fi
    
}

createRootDiretory

year=$(date +"%Y")
month_dir=$(date +%B | tr '[:lower:]' '[:upper:]')
directories=($(find $root_dir -maxdepth 1 -type d -name "[0-9]*" -printf "%f\n" | sort -rn))
num_dirs=${#directories[@]}


formatNameMounth () {
    echo "$(date +"%d_%b" | tr '[:lower:]' '[:upper:]')"
}

loading_spinner() {
    echo $1
    local delay=0.3
    local spinstr='|/-\'
    local counter=0
    while [ $counter -le 10 ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        ((counter++))
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    
    printf "    \b\b\b\b"
}


createNewFileYear() {
    #echo "Criando sistemas de arquivos..."
    loading_spinner "Criando sistema de arquivo"
    mkdir "$root_dir/$year"
    echo "Diretório criado: $year"
    #cd $year
    mkdir "$root_dir/$year/$month_dir"
    #cd $month_dir
    #$(date +%B | tr '[:lower:]' '[:upper:]')
    createNewFile
}

createNewFileMonth(){
    loading_spinner "Criando pasta mẽs"
    mkdir "$root_dir/$year/$month_dir"
    echo "Diretório criado: $month_dir"
    
    createNewFile
    
}

createNewFile(){
    nome_arquivo=$(date +"%d_%b" | tr '[:lower:]' '[:upper:]').txt
    echo "$(date +"%^d de %^b")" > "$root_dir/$year/$month_dir/$nome_arquivo"
    nvim "$root_dir/$year/$month_dir/$nome_arquivo"
    
}

title(){
    echo "$(echo "$1" | tr '[:lower:]' '[:upper:]')"
}

updateYear(){
    directories=($(find $root_dir -maxdepth 1 -type d -name "[0-9]*" -printf "%f\n" | sort -rn))
    num_dirs=${#directories[@]}
}


showIntro(){
    echo -e "\e[35m...."
    echo "                                .'' .'''"
    echo ".                             .'   :"
    echo "\\                          .:    :"
    echo " \\                        _:    :       ..----.._"
    echo "  \\                    .:::.....:::.. .'         ''."
    echo "   \\                 .'  #-. .-######'     #        '."
    echo "    \\                 '.##'/ ' ################       :"
    echo "     \\                  #####################         :"
    echo "      \\               ..##.-.#### .''''###'.._        :"
    echo "       \\             :--:########:            '.    .' :"
    echo "        \\..__...--.. :--:#######.'   '.         '.     .:"
    echo "        :     :  : : '':'-:'':'::        .         '.  .' :"
    echo "        '---'''..: :    ':    '..'''.      '.        :'"
    echo "           \\  :: : :     '      ''''''.     '.      .:"
    echo "            \\ ::....:..:...................'...:.......'     '."
    
    
    echo -e "\e[33m"
    echo "___  ___               _       ______  _                     "
    echo "|  \/  |              (_)      |  _  \(_)                    "
    echo "| .  . |  __ _   __ _  _   ___ | | | | _   __ _  _ __  _   _ "
    echo "| |\/| | / _\` | / _\` || | / __|| | | || | / _\` || '__|| | | |"
    echo "| |  | || (_| || (_| || || (__ | |/ / | || (_| || |   | |_| |"
    echo "\_|  |_/ \__,_| \__, ||_| \___||___/  |_| \__,_||_|    \__, |"
    echo "                 __/ |                                  __/ |"
    echo "                |___/                                  |___/ "
    echo ""
    echo -e "\e[31mAUTHOR: FELYPE RANGEL <FelypeInvictus>"
    echo -e "\e[31mVERSION: 1.0.0" 
    echo -e "\e[31mDESCRIPTION: A SIMPLE PERSONAL DIARY FOR USE IN YOUR LINUX TERMINAL. ENJOY IT!"
    echo -e "\e[34mUPDATE/INFO: https://github.com/FelypeInvictus/MagicDiary"
    echo -e "\e[31mCOPYRIGHT © 2024 FELYPE RANGEL"
    echo -e "\e[0m"
    
}


showIntro

while true ; do
    
    counter=0
    
    updateYear
    
    selectedYear(){
        if [[ $num_dirs -gt 0 && $year -eq ${directories[$counter]} ]]; then
            
            title "Anos disponíveis:"
            for ((i=0; i<$num_dirs; i++)); do
                
                
                echo "$(($i+1)). ${directories[$i]}"
            done
            
            read -p "Digite o número corresponde ao ano que deseja acessar: (ou Q - SAIR) " dir_choice
            
            
            
            if [[ $dir_choice =~ ^[0-9]+$ ]]; then
                
                selected_year=${directories[$(($dir_choice-1))]}
                
                if [[ -d "$root_dir/$selected_year" ]]; then
                    
                    
                    
                    if [[ -d "$root_dir/$selected_year/$month_dir" || $year -ne $selected_year ]]; then
                        
                        
                        
                        
                        subdirectories=($(find "$root_dir/$selected_year" -maxdepth 1 -type d -name "[A-Z]*" -printf "%f\n" | sort))
                        num_subdirs=${#subdirectories[@]}
                        
                        
                        
                        selectedMonth(){
                            if [[ $num_subdirs -gt 0 ]]; then
                                
                                clear
                                showIntro
                                title "Meses disponíveis:"
                                
                                for ((i=0; i<$num_subdirs; i++)); do
                                    echo "$(($i+1)). ${subdirectories[$i]}"
                                done
                                
                                read -p "Digite o número que corresponde ao mês: (ou R - retornar ou Q - sair)  " subdir_choice
                                
                                if [[ $subdir_choice =~ ^[0-9]+$ ]]; then
                                    if [[ $subdir_choice -gt $num_subdirs || $subdir_choice -le 0 ]]; then
                                        selectedMonth
                                    fi
                                    
                                    selected_subdir=${subdirectories[$(($subdir_choice-1))]}
                                    echo "Você escolheu $selected_subdir"
                                    num_files=$(ls "$root_dir/$selected_year/$selected_subdir" *.txt 2> /dev/null | wc -l)
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    if [[ "$num_files" -gt 0 ]]
                                    then
                                        
                                        selectedListText(){
                                            txt_files=($(find "$root_dir/$selected_year/$selected_subdir" -maxdepth 1 -type f -name "*.txt" -printf "%f\n" | sort))
                                            num_files=${#txt_files[@]}
                                            
                                            clear
                                            showIntro
                                            echo ""
                                            echo -e "\e[32m$selected_subdir \e[0m"
                                            echo ""
                                            
                                            echo "Lista dos diarios:"
                                            for ((i=0; i<$num_files; i++)); do
                                                echo "$(($i+1)). ${txt_files[$i]}"
                                            done
                                            
                                            
                                            
                                            read -p "Selecione o arquivo: (ou C - CRIAR NOVO DIARIO | R - RETORNAR | Q - SAIR) " file_choice
                                            if [[ $file_choice =~ ^[0-9]+$ ]]; then
                                                if [[ $file_choice -gt $num_files || $file_choice -le 0 ]]; then
                                                    echo "Digite apenas os numeros mostrados!"
                                                    selectedListText
                                                fi
                                                
                                                selected_file=${txt_files[$(($file_choice-1))]}
                                                title "você escolheu editar $selected_file"
                                                
                                                
                                                
                                                
                                                
                                                echo "[E - EDITAR | V - VISUALIZAR ARQUIVO | D - DELETAR |R - RETORNAR | Q - SAIR]"
                                                read -p "O que deseja fazer? " choice
                                                
                                                file_tolowercase=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
                                                
                                                case $file_tolowercase in
                                                    "v")
                                                        echo "Digite (Q) pra sair do visualizador!"
                                                        loading_spinner
                                                        bat --paging=always "$root_dir/$selected_year/$selected_subdir/$selected_file"
                                                        selectedListText
                                                    ;;
                                                    "e")
                                                        nvim "$root_dir/$selected_year/$selected_subdir/$selected_file"
                                                        selectedListText
                                                        
                                                    ;;
                                                    
                                                    "d")
                                                        
                                                        read -p "Tem certeza? [Y/N]" choice_delete
                                                        if [[ $choice_delete =~ ^[yY]$ ]]; then
                                                            loading_spinner "Removendo..."
                                                            rm -rf "$root_dir/$selected_year/$selected_subdir/$selected_file"
                                                            echo "Removido!"
                                                            
                                                            selectedListText
                                                            elif [[ $choice_delete =~ ^[nN]$ ]]; then
                                                            echo "Ok!"
                                                            selectedListText
                                                            
                                                        fi
                                                    ;;
                                                    
                                                    
                                                    "r")
                                                        selectedListText
                                                    ;;
                                                    
                                                    
                                                    
                                                    "q")
                                                        exit 1
                                                    ;;
                                                    *)
                                                        echo "Digite caracteres validos!."
                                                        selectedListText
                                                    ;;
                                                esac
                                                
                                                
                                                
                                            else
                                                
                                                file_choice_tolowercase=$(echo "$file_choice" | tr '[:upper:]' '[:lower:]')
                                                case $file_choice_tolowercase in
                                                    
                                                    "c")
                                                        nome_arquivo=$(date +"%d_%b" | tr '[:lower:]' '[:upper:]').txt
                                                        
                                                        # Compara arquivos já existentes
                                                        for ((i=0; i<$num_files; i++)); do
                                                            echo "$nome_arquivo ${txt_files[$i]}"
                                                            if [[ "$nome_arquivo" == "${txt_files[$i]}" ]]; then
                                                                echo "O arquivo já existe!"
                                                                #exit 1
                                                            fi
                                                        done
                                                        createNewFile
                                                        
                                                        selectedListText
                                                    ;;
                                                    "r")
                                                        selectedMonth
                                                    ;;
                                                    
                                                    "q")
                                                        exit 1
                                                    ;;
                                                    
                                                    *)
                                                        echo "Escolha inválida"
                                                        selectedListText
                                                    ;;
                                                esac
                                                
                                            fi
                                        }
                                        
                                        selectedListText
                                    else
                                        echo "Não há arquivos .txt para editar."
                                        echo "Será gerado um arquivo agora..."
                                        loading_spinner "Loading..."
                                        #sleep 10
                                        createNewFile
                                    fi
                                    
                                else
                                    
                                    month_tolowercase=$(echo "$subdir_choice" | tr '[:upper:]' '[:lower:]')
                                    case $month_tolowercase in
                                        "r")
                                            
                                            
                                            selectedYear
                                            
                                        ;;
                                        
                                        "q")
                                            exit 1
                                        ;;
                                        
                                        *)
                                            selectedMonth
                                        ;;
                                    esac
                                    
                                fi
                                
                                
                            else
                                echo "Não há subdiretórios disponíveis."
                                
                            fi
                        }
                        selectedMonth
                    else
                        createNewFileMonth
                    fi
                else
                    echo "O diretório selecionado não existe."
                    exit 1
                fi
                
                
            else
                
                year_choice_tolowercase=$(echo "$dir_choice" | tr '[:upper:]' '[:lower:]')
                case $year_choice_tolowercase in
                    "q")
                        exit 1
                    ;;
                    
                    *)
                        clear
                        showIntro
                        echo -e "\e[33m                   Digite apenas numeros!\e[0m"
                        echo ""
                        
                        
                    ;;
                esac
                
                
                
                
                
            fi
            
        else
            
            createNewFileYear
        fi
    }
    
    selectedYear
done


