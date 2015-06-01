<?php include('login.php'); ?>
<?php
	
	$pdt = $_GET['pdt'];

	/* Connexion à la base de données et execution de la requete qui get l'outils demandé */
	$con = pg_connect("host=$host dbname=$db user=$user password=$pass")
    or die('<div class="alert alert-danger" role="alert"><p>La connexion à la base données a échoué !</p></div><a href="categorie.php"><button type="button" class="btn btn-info">Retour</button></a><br/></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');

	$query = "SELECT DISTINCT ON(image) nomoutil,marque,tarif,image,categorie FROM OUTILS WHERE image='".$pdt."';"; 

	$rs = pg_query($con, $query) or die('<div class="alert alert-danger" role="alert"><p>La récupération des données a échoué</p></div><a href="categorie.php"><button type="button" class="btn btn-info">Retour</button></a><br/></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');
	
	/* Affichage de la requête */
	echo '<ul class="ficheOutil">';
	$row = pg_fetch_assoc($rs);
?>
	<hr class="ficheOutil">
	<li><h2><?=$row['nomoutil']?></h2>
	<div class="ficheOutil"><p class="ficheOutil">Marque : <?=$row['marque']?><br/>Tarif : <?=$row['tarif']?>€ par jour<br/></p>
	<a class="ficheOutil" href="categorieSpe.php?id=<?=$row['categorie']?>">
	<button type="button" class="btn btn-info">Retour</button></a></div>
	<img src="../img/outils/<?=$row['image']?>.jpg"></li>
<?php
	echo '</ul>';

	/* Fermeture de la connexion à la base de données */
	pg_close($con);

?>