rm hodnoceni.txt
for i in $(seq 1 42); do
	curl -s $i https://kultura.zpravy.idnes.cz/recenze-mirky-spacilove.aspx?strana=$i | grep "span class=\"rating\""| cut -d'>' -f2 | cut -d' ' -f1 >> hodnoceni.txt
done

sort -n hodnoceni.txt | uniq -c

#   1 0
#   2 5
#   9 10
#   5 15
#  11 20
#  13 25
#  37 30
#  26 35
# 105 40
#  42 45
# 269 50
# 147 55
# 330 60
# 163 65
# 210 70
#  56 75
#  62 80
#   4 85
#   2 90
