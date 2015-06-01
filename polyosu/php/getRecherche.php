<?php include('login.php'); ?>
<?php

	$sh='%'.$_GET['recherche'].'%';

	/* Connexion à la base de données et execution de la requete qui get les outils corespondant à une catégorie */
	$con = pg_connect("host=$host dbname=$db user=$user password=$pass")
    or die('<div class="alert alert-danger" role="alert"><p>La connexion à la base données a échoué !</p></div><a href="../index.php"><button type="button" class="btn btn-info">Retour</button></a><br/></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');

	$query = 'SELECT DISTINCT ON(image) nomoutil,marque,tarif,image,categorie FROM OUTILS WHERE (lower(nomoutil) LIKE lower(\''.$sh.'\')) OR lower(marque) LIKE lower(\''.$sh.'\');'; 

	$rs = pg_query($con, $query) or die('<div class="alert alert-danger" role="alert"><p>La récupération des données a échoué</p></div><a href="../.php"><button type="button" class="btn btn-info">Retour</button></a><br/></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');
	
	if(!empty(pg_fetch_all($rs))){
		/* Affichage de la reponse */
		echo '<h1 class="recherche">Recherche</h1>';
		echo '<ul class="recherche">';
		while ($row = pg_fetch_assoc($rs)) {
?>
			<hr class="recherche">
			<li class="recherche"><h2><?=$row['nomoutil']?></h2>
			<div class="recherche"><p class="recherche">Marque : <?=$row['marque']?><br/>Tarif : <?=$row['tarif']?>€ par jour<br/></p>
			<a class="recherche" href="ficheOutil.php?pdt=<?=$row['image']?>">
			<button type="button" class="btn btn-info">Consulter</button></a></div>
			<img src="../img/outils/<?=$row['image']?>.jpg"></li>
<?php
		};
		echo '</ul>';
		}
	else
		{
			echo '<div class="alert alert-info" role="alert"><p>Désolé, il n\'y a aucun résultat pour votre recherche</p></div>';
		}

	/* Fermeture de la connexion à la base de données */
	pg_close($con);
?>