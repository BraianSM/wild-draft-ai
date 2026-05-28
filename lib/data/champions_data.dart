// DATOS: Contiene la lista completa de campeones de Wild Rift
// Cada campeón tiene su nombre, rol y URL de imagen EXACTA de Data Dragon
import '../models/champion.dart';

class ChampionsData { 
  // Lista estática con todos los campeones de Wild Rift y sus URLs exactas
  static List<Champion> getAll() {
    return [
      // Base URL de Data Dragon para todas las imágenes
      // Formato: https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/NOMBRE.png
      
      Champion(
        name: 'Aatrox',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Aatrox.png',
        isAD: true,
        hasHealing: true,
        isMidGame: true,
      ),
      Champion(
        name: 'Ahri',
        roles: ['MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Ahri.png',
        isAP: true,
        hasCC: true,
        isMidGame: true,
      ),
      Champion(
        name: 'Akali',
        roles: ['MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Akali.png',
        isAP: true,
        isMidGame: true,
      ),
      Champion(
        name: 'Akshan',
        roles: ['MID', 'TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Akshan.png',
        isAD: true,
        isEarlyGame: true,
        usesAutoAttacks: true,
      ),
      Champion(
        name: 'Alistar',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Alistar.png',
        isTank: true,
        isMelee: true,
        hasEngage: true,
        hasHealing: true,
      ),
      Champion(
        name: 'Amumu',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Amumu.png',
        isAP: true,
        isTank: true,
        hasCC: true,
        hasEngage: true,
        isMelee: true,
        scalesLateGame: true,
      ),
      Champion(
        name: 'Annie',
        roles: ['MID', 'SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Annie.png',
        isAP: true,
        hasCC: true,
        hasEngage: true,
        isMidGame: true,
      ),
      Champion(
        name: 'Ashe',
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Ashe.png',
        usesAutoAttacks: true,
        hasCC: true,
        isAD: true,
        isMidGame: true,
        hasEngage: true,
      ),
      Champion(
        name: 'Aurelion Sol',
        roles: ['MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/AurelionSol.png',
        isAP: true,
        hasCC: true,
        scalesLateGame: true,
        hasEngage: true,
        ),
      Champion(
        name: 'Aurora', 
        roles: ['MID', 'TOP'], 
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.14.1/img/champion/Aurora.png',
        isAP: true,
        isMidGame: true,
        ),
      Champion(
        name: 'Blitzcrank',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Blitzcrank.png',
        isAP: true,
        isTank: true,
        hasEngage: true,
        isEarlyGame: true,
        isMelee: true,
      ),
      Champion(
        name: 'Brand',
        roles: ['MID', 'SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Brand.png',
        isAP: true,
        hasCC: true,
        scalesLateGame: true,
        hasEngage: true,
        ),
      Champion(
        name: 'Braum',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Braum.png',
        isMelee: true,
        hasCC: true,
        hasEngage: true,
        isMidGame: true
      ),
      Champion(
        name: 'Caitlyn',
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Caitlyn.png',
        isAD: true,
        usesAutoAttacks: true,
        hasCC: true,
        isEarlyGame: true,
      ),
      Champion(
        name: 'Camille',
        roles: ['TOP', 'JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Camille.png',
        isAD: true,
        isEarlyGame: true,
        hasCC: true,
        isMelee: true,
        isMidGame: true,
      ),
      Champion(
        name: 'Corki',
        roles: ['ADC', 'MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Corki.png',
        isAD: true,
        usesAutoAttacks: true,
        isMidGame: true,
      ),
      Champion(
        name: 'Darius',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Darius.png',
        isAD: true,
        isMelee: true,
        isEarlyGame: true,
        hasCC: true,
        hasEngage: true,
      ),
      Champion(
        name: 'Diana',
        roles: ['MID', 'JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Diana.png',
        isAP: true,
        isMelee: true,
        hasCC: true,
        isMidGame: true,
      ),
      Champion(
        name: 'Dr. Mundo',
        roles: ['TOP', 'JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/DrMundo.png',
        isAP: true,
        isTank: true,
        hasHealing: true,
        scalesLateGame: true,
      ),
      Champion(
        name: 'Draven',
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Draven.png',
        isAD: true,
        usesAutoAttacks: true,
        isEarlyGame: true,
        hasCC: true,
      ),
      Champion(
        name: 'Ekko',
        roles: ['MID', 'JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Ekko.png',
      ),
      Champion(
        name: 'Evelynn',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Evelynn.png',
      ),
      Champion(
        name: 'Ezreal',
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Ezreal.png',
      ),
      Champion(
        name: 'Fiora',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Fiora.png',
      ),
      Champion(
        name: 'Fizz',
        roles: ['MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Fizz.png',
      ),
      Champion(
        name: 'Galio',
        roles: ['MID', 'SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Galio.png',
      ),
      Champion(
        name: 'Garen',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Garen.png',
      ),
      Champion(
        name: 'Gnar',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Gnar.png',
      ),
      Champion(
        name: 'Gragas',
        roles: ['JG', 'TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Gragas.png',
      ),
      Champion(
        name: 'Graves',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Graves.png',
      ),
      Champion(
        name: 'Gwen',
        roles: ['TOP', 'JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Gwen.png',
      ),
      Champion(
        name: 'Irelia',
        roles: ['TOP', 'MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Irelia.png',
      ),
      Champion(
        name: 'Janna',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Janna.png',
      ),
      Champion(
        name: 'Jarvan IV',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/JarvanIV.png',
      ),
      Champion(
        name: 'Jax',
        roles: ['TOP', 'JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Jax.png',
      ),
      Champion(
        name: 'Jayce',
        roles: ['TOP', 'MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Jayce.png',
      ),
      Champion(
        name: 'Katarina', 
        roles: ['MID'], 
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Katarina.png'
        ),
      Champion(
        name: 'Jhin',
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Jhin.png',
      ),
      Champion(
        name: 'Jinx',
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Jinx.png',
      ),
      Champion(
        name: "Kai'Sa",
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Kaisa.png',
      ),
      Champion(
        name: 'Karma',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Karma.png',
      ),
      Champion(
        name: 'Kassadin',
        roles: ['MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Kassadin.png',
      ),
      Champion(
        name: 'Kayle',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Kayle.png',
      ),
      Champion(
        name: 'Kennen',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Kennen.png',
      ),
      Champion(
        name: "Kha'Zix",
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Khazix.png',
      ),
      Champion(
        name: "Kog'Maw",
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/KogMaw.png',
      ),
      Champion(
        name: "K'Sante",
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/KSante.png',
      ),
      Champion(
        name: 'Lee Sin',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/LeeSin.png',
      ),
      Champion(
        name: 'Leona',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Leona.png',
      ),
      Champion(
        name: 'Lillia',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Lillia.png',
      ),
      Champion(
        name: 'Lissandra', 
        roles: ['MID', 'TOP', 'SUPP'], 
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Lissandra.png'
      ),
      Champion(
        name: 'Lucian',
        roles: ['ADC', 'MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Lucian.png',
      ),
      Champion(
        name: 'Lulu',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Lulu.png',
      ),
      Champion(
        name: 'Lux',
        roles: ['MID', 'SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Lux.png',
      ),
      Champion(
        name: 'Malphite',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Malphite.png',
      ),
      Champion(
        name: 'Maokai',
        roles: ['JG', 'SUPP', 'TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Maokai.png',
      ),
      Champion(
        name: 'Master Yi',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/MasterYi.png',
      ),
      Champion(
        name: 'Miss Fortune',
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/MissFortune.png',
      ),
      Champion(
        name: 'Mordekaiser',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Mordekaiser.png',
      ),
      Champion(
        name: 'Morgana',
        roles: ['SUPP', 'MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Morgana.png',
      ),
      Champion(
        name: 'Nami',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Nami.png',
      ),
      Champion(
        name: 'Nasus',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Nasus.png',
      ),
      Champion(
        name: 'Nautilus',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Nautilus.png',
      ),
      Champion(
        name: 'Nilah', 
        roles: ['ADC'], 
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.21.1/img/champion/Nilah.png'
        ),
      Champion(
        name: 'Nocturne', 
        roles: ['JG'], 
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Nocturne.png'
        ),
        Champion(
          name: 'Norra', 
          roles: ['MID'], 
          imageUrl: 'https://wiki.leagueoflegends.com/en-us/images/Norra_OriginalSquare.png'
          ),
      Champion(
        name: 'Nunu y Willump',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Nunu.png',
      ),
      Champion(
        name: 'Olaf',
        roles: ['TOP', 'JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Olaf.png',
      ),
      Champion(
        name: 'Orianna',
        roles: ['MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Orianna.png',
      ),
      Champion(
        name: 'Ornn',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Ornn.png',
      ),
      Champion(
        name: 'Pantheon',
        roles: ['TOP', 'JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Pantheon.png',
      ),
      Champion(
        name: 'Pyke',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Pyke.png',
      ),
      Champion(
        name: 'Rakan',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Rakan.png',
      ),
      Champion(
        name: 'Rammus',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Rammus.png',
        isTank: true,
        hasCC: true,
        isMelee: true,
        ),
      Champion(
        name: 'Ryze', 
        roles: ['MID', 'TOP'], 
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Ryze.png'
        ),
      Champion(
        name: 'Renekton',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Renekton.png',
      ),
      Champion(
        name: 'Rengar',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Rengar.png',
      ),
      Champion(
        name: 'Riven',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Riven.png',
      ),
      Champion(
        name: 'Poppy', 
        roles: ['TOP', 'JG'], 
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Poppy.png'
        ),
      Champion(
        name: 'Rumble', 
        roles: ['TOP'], 
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.21.1/img/champion/Rumble.png'
        ),
      Champion(
        name: 'Samira',
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Samira.png',
      ),
      Champion(
       name: 'Shen', 
       roles: ['TOP', 'JG', 'SUPP'], 
       imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Shen.png'
      ),
      Champion(
        name: 'Senna',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Senna.png',
      ),
      Champion(
        name: 'Seraphine',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Seraphine.png',
      ),
      Champion(
        name: 'Sett',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Sett.png',
      ),
      Champion(
        name: 'Shyvana',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Shyvana.png',
      ),
      Champion(
        name: 'Singed',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Singed.png',
      ),
      Champion(
        name: 'Sion',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Sion.png',
      ),
      Champion(
        name: 'Sivir',
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Sivir.png',
      ),
      Champion(
        name: 'Sona',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Sona.png',
      ),
      Champion(
        name: 'Soraka',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Soraka.png',
      ),
      Champion(
        name: 'Swain', 
        roles: ['MID', 'TOP', 'SUPP'], 
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.21.1/img/champion/Swain.png'
        ),
      Champion(
        name: 'Syndra', 
        roles: ['MID'], 
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.21.1/img/champion/Syndra.png'
        ),
      Champion(
        name: 'Taliyah',
        roles: ['MID', 'JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Taliyah.png',
      ),
      Champion(
        name: 'Talon',
        roles: ['MID', 'JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Talon.png',
      ),
      Champion(
        name: 'Teemo',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Teemo.png',
      ),
      Champion(
        name: 'Thresh',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Thresh.png',
      ),
      Champion(
        name: 'Tristana',
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Tristana.png',
      ),
      Champion(
        name: 'Tryndamere',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Tryndamere.png',
      ),
      Champion(
        name: 'Twisted Fate',
        roles: ['MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/TwistedFate.png',
      ),
      Champion(
        name: 'Twitch',
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Twitch.png',
      ),
      Champion(
        name: 'Urgot',
        roles: ['TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Urgot.png',
      ),
      Champion(
        name: 'Varus',
        roles: ['ADC', 'TOP', 'MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Varus.png',
      ),
      Champion(
        name: 'Vayne',
        roles: ['ADC', 'TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Vayne.png',
      ),
      Champion(
        name: 'Veigar',
        roles: ['MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Veigar.png',
      ),
      Champion(
        name: "Vel'Koz", 
        roles: ['MID', 'SUPP'], 
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Velkoz.png',
        ),
      Champion(
        name: 'Vi',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Vi.png',
      ),
      Champion(
        name: 'Viego', 
        roles: ['JG'], 
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.21.1/img/champion/Viego.png'
        ),
      Champion(
        name: 'Vladimir',
        roles: ['MID', 'TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Vladimir.png',
      ),
      Champion(
        name: 'Volibear',
        roles: ['TOP', 'JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Volibear.png',
      ),
      Champion(
        name: 'Warwick',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Warwick.png',
      ),
      Champion(
        name: 'Wukong',
        roles: ['TOP', 'JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/MonkeyKing.png',
      ),
      Champion(
        name: 'Xayah',
        roles: ['ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Xayah.png',
      ),
      Champion(
        name: 'Xin Zhao',
        roles: ['JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/XinZhao.png',
      ),
      Champion(
        name: 'Yasuo',
        roles: ['MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Yasuo.png',
        isAD: true,
        hasEngage: true,
        isMelee: true,
        usesAutoAttacks: true,
      ),
      Champion(
        name: 'Yone',
        roles: ['MID', 'TOP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Yone.png',
      ),
      Champion(
        name: 'Yuumi',
        roles: ['SUPP'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Yuumi.png',
      ),
      Champion(
        name: 'Zed',
        roles: ['MID', 'JG'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Zed.png',
      ),
      Champion(
        name: 'Zilean', 
        roles: ['SUPP'], 
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Zilean.png'
        ),
      Champion(
        name: 'Ziggs',
        roles: ['MID', 'ADC'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Ziggs.png',
      ),
      Champion(
        name: 'Zoe',
        roles: ['MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Zoe.png',
      ),
      Champion(
        name: 'Zyra',
        roles: ['SUPP', 'MID'],
        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Zyra.png',
      ),
    ];
  }
}