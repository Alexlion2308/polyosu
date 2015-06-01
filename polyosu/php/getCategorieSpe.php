<?php include('login.php'); ?>
<?php

	$id = $_GET['id'];

	/* Connexion à la base de données et execution de la requete qui get les outils corespondant à une catégorie */
	$con = pg_connect("host=$host dbname=$db user=$user password=$pass")
    or die('<div class="alert alert-danger" role="alert"><p>La connexion à la base données a échoué !</p></div><a href="categorie.php"><button type="button" class="btn btn-info">Retour</button></a><br/></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');

	$query = 'SELECT DISTINCT ON(image) nomoutil,marque,tarif,image,categorie FROM OUTILS, CATEGORIE WHERE categorie=idcategorie AND idcategorie='.$id.';'; 

	$rs = pg_query($con, $query) or die('<div class="alert alert-danger" role="alert"><p>La récupération des données a échoué</p></div><a href="categorie.php"><button type="button" class="btn btn-info">Retour</button></a><br/></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');
	
	$query = 'SELECT * FROM CATEGORIE WHERE idcategorie='.$id.';'; 

	$rscat = pg_query($con, $query) or die('<div class="alert alert-danger" role="alert"><p>La récupération des données a échoué</p></div><a href="categorie.php"><button type="button" class="btn btn-info">Retour</button></a><br/></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');
	
	/* Affichage de la requête sous forme de tableau */
	echo '<h1 class="categorieSpe">Categorie : '.pg_fetch_all($rscat)['0']['nomcategorie'].'</h1>';
	echo '<ul class="categorieSpe">';
	while ($row = pg_fetch_assoc($rs)) {
?>
	<hr class="categorieSpe">
	<li><h2><?=$row['nomoutil']?></h2>
	<div class="categorieSpe"><p class="categorieSpe">Marque : <?=$row['marque']?><br/>Tarif : <?=$row['tarif']?>€ par jour<br/></p>
	<a class="categorieSpe" href="ficheOutil.php?pdt=<?=$row['image']?>">
	<button type="button" class="btn btn-info">Consulter</button></a></div>
	<img src="../img/outils/<?=$row['image']?>.jpg"></li>
<?php
	};
	echo '</ul>';

	/* Fermeture de la connexion à la base de données */
	pg_close($con);

?>