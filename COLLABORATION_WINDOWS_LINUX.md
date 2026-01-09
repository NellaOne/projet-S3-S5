# 🤝 Guide de Collaboration Windows/Linux

## ✅ Aucun problème de compatibilité!

TaxiBrousse est **100% cross-platform** car:
- Spring Boot fonctionne identiquement partout
- PostgreSQL est identique
- Java 17 est identique

## 📋 Recommandations

### 1. Configuration Git
Créer `.gitattributes` à la racine:
```
* text=auto
*.java text eol=lf
*.xml text eol=lf
*.sql text eol=lf
*.properties text eol=lf
*.md text eol=lf
```

Exécuter:
```bash
git config core.safecrlf true
```

### 2. Chemins dans le Code
Toujours utiliser les chemins relatifs:
```java
// ✅ BON
String path = "src/main/resources/data.txt";

// ❌ MAUVAIS
String path = "C:\\Users\\User\\...";
```

### 3. Variables d'Environnement
```bash
# Linux
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$PATH:$JAVA_HOME/bin

# Windows (déjà dans IDE)
```

### 4. Build
```bash
# Windows
mvnw.cmd clean install

# Linux
./mvnw clean install
```

### 5. Database
Les deux utilisent PostgreSQL avec la même config:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/taxi_brousse
spring.datasource.username=postgres
spring.datasource.password=nella
```

### 6. Port Maven
Le port 8080 fonctionne sur les deux OS sans problème.

## 🎯 Flux de Collaboration

1. **Windows Person** → Git push
2. **Linux Person** → Git pull
3. **Pas de conflits de ligne**
4. **Code identique** sur les deux machines

## 📝 Checklist Avant de Collaborer

- [ ] `.gitattributes` committé
- [ ] Java 17 installé sur les deux machines
- [ ] Maven configuré sur les deux
- [ ] PostgreSQL connecté sur les deux
- [ ] Même version de Spring Boot (3.5.9)
- [ ] Même `application.properties`
- [ ] Test: `mvnw clean compile` sur les deux

## ⚠️ Pièges à Éviter

❌ Ne jamais hardcoder les chemins Windows: `C:\Users\...`  
❌ Ne pas committer les `.class` ou `target/`  
❌ Ne pas modifier les line endings manuellement  
❌ Ne pas utiliser des chemins absolus  

## 🔍 Pour Vérifier la Compatibilité

```bash
# Affiche version Java
java -version

# Affiche version Maven
mvn -version

# Test compilation
mvn clean compile
```

Les deux machines devraient avoir exactement les mêmes versions!

---

**👍 Vous êtes prêts pour une collaboration harmonieuse!**
