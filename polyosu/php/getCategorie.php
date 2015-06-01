<?php include('login.php'); ?>
<?php
	/* Connexion à la base de données et execution de la requete qui get la table categorie en entier */
	$con = pg_connect("host=$host dbname=$db user=$user password=$pass")
    or die('<div class="alert alert-danger" role="alert"><p>La connexion à la base données a échoué !</p></div><a href="../index.php"><button type="button" class="btn btn-info">Retour</button></a><br/></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');

	$query = "SELECT * FROM CATEGORIE;"; 

	$rs = pg_query($con, $query) or die('<div class="alert alert-danger" role="alert"><p>La récupération des données a échoué</p></div><a href="../index.php"><button type="button" class="btn btn-info">Retour</button></a><br/></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');

	/* Affichage de la table categorie */
	echo '<ul class="categorie">';
	while ($row = pg_fetch_assoc($rs)) {
?>
	<hr class="categorie">
	<li class="categorie"><h2> <?=$row['nomcategorie']?></h2>
	<a href="categorieSpe.php?id=<?=$row['idcategorie'] ?>">
	<button type="button" class="btn btn-info">Consulter</button></a></li>
<?php
	};
	echo '</ul>';

	/* Fermeture de la connexion à la base de données */
	pg_close($con);
?>