#! /bin/bash

# скрипт сортирует папку с png-файлами по колличеству цветов, используя утилиту imagemagic.identify

messages=();

function print_messages {
  for mess in ${!messages[*]} 
  do
    printf "${messages[$mess]} \n";
  done
}

function get_count_png {
  local path="$1*.png";
  local count_files=`ls -l 2> /dev/null $path | wc -l`;
  echo $count_files;
}

function key_processing {

  while [[ -n $1 ]]
  do
    sleep 1s;
    case  $1 in 
      -d)
        if [[ -n $2 ]] 
        then 
          if [[ -d $2 ]]
          then
            count=$( get_count_png $2 );
            if [[ $count -gt 0 ]]
            then
              directory_png=$2;
            else
              messages[${#messages[*]}]='В указанной директории не содержиться файлов с расширением .png'
              break 2;
            fi
          else
            messages[${#messages[*]}]="\"$2\" - не являеться директорией!!!"
            break 2;
          fi
        else
          messages[${#messages[*]}]='Путь к дирректории не введен'
          break 2;
        fi
        shift ;;
      -f) 
        if [[ -n $2 && -d $2 ]]
        then
          target_directory=$2;
        else 
          messages[${#messages[*]}]='Введите корректный путь для размещения файлов';
          break 2;
        fi
        shift;;
      -cc)
        regu='^[0-9]+([.][0-9]+)?$';
        if [[ $2 =~ $regu ]]
        then
          echo huy
          color_count=$2;
        else
          messages[${#messages[*]}]='Введите число'; 
          break 2;
        fi;
        shift;;
      *) messages[${#messages[*]}]="Параметр \"$1\" неизвестен";
    esac
    shift
  done

}

key_processing $*; #проверка ключей на корректность

#место для хранения отфильтрованых файлов
if [[ $target_directory/parse ]]
then
  rm -r "$target_directory/parse";
  echo Папка 'parse' удалена
fi
mkdir $target_directory/parse;
mkdir "$target_directory/parse/1parse" "$target_directory/parse/2parse" "$target_directory/parse/3parse";
cp -r $directory_png/*.png $target_directory/parse/;

path_png_arr=( $(ls $target_directory/parse/*.png) );

expressions=("Image: " "Colors: ");
i=0;
echo Получение целевых параметров: $'\n'0%;
for path in ${path_png_arr[*]}
do
  IFS=$'\n';
  self=`identify -verbose $path`;
  IFS=$'\t';
  png_info_arr[${#png_info_arr[*]}]=`echo $self | egrep "${expressions[1]}|${expressions[0]}"`;
  i=$(( $i + 1 ));
  echo "$(( $i * 100 / $count ))%";
done;

for item in ${png_info_arr[*]}
do
  IFS=$'\t';
  path=`echo $item | egrep "${expressions[0]}"`;
  colors=`echo $item | egrep "${expressions[1]}"`;
  IFS=': ';
  path=(  ${path[0]} );
  path=${path[1]};
  colors=( ${colors[0]} );
  colors=${colors[1]};
  if [[ -z $colors || $colors -ge 200 ]]
  then
    mv $path $target_directory/parse/1parse;
  elif [[ $colors -ge 100 ]]
  then
    mv $path $target_directory/parse/2parse;
  else
    mv $path $target_directory/parse/3parse;
  fi
done

print_messages;
