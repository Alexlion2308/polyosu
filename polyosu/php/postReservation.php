<?php include('login.php'); ?>
<?php

	setlocale(LC_ALL, array('fr_FR.UTF-8','fr_FR@euro','fr_FR','french'));
	date_default_timezone_set('Europe/Paris');

	$pdt = $_GET['pdt'];
	$nom = $_POST['nom'];
	$prenom = $_POST['prenom'];
	$email = $_POST['email'];
	$tel = $_POST['tel'];
	$datedebut=$_POST['datedebut'];
	$datefin=$_POST['datefin'];
	$dd=strtotime($_POST['datedebut']);
	$df=strtotime($_POST['datefin']);

	$codeerreur = 0;

	/* Connexion à la base de données */
	$con = pg_connect("host=$host dbname=$db user=$user password=$pass") or die('<div class="alert alert-danger" role="alert"><p>La connexion à la base données a échoué ! Vous pouvez revenir au formulaire en cliquant sur le bouton modifier.</p></div><a href="ficheOutil.php?pdt='.$pdt.'&nom='.$nom.'&prenom='.$prenom.'&email='.$email.'&tel='.$tel.'&datedebut='.$datedebut.'&datefin='.$datefin.'"><button type="button" class="btn btn-info">Modifier</button></a><br/></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');
	/* correspond au fail de la connexion à la base de données */

	/* La requête permetant de selectionner les idoutil disponible */
	$query = "((SELECT idoutil from outils where image='".$pdt."') EXCEPT (SELECT idemprunt from emprunt where dateretour>='".$dd."')) EXCEPT (SELECT idreservation from reservation where datefin>='".$dd."' AND datedebut<='".$df."');"; 

	/* Execution de la requête */
	$rs = pg_query($con, $query) or die('<div class="alert alert-danger" role="alert"><p>La demande de disponibilité à échoué, veuillez verifier vos champs date en appuyant sur modifier.</p></div><a href="ficheOutil.php?pdt='.$pdt.'&nom='.$nom.'&prenom='.$prenom.'&email='.$email.'&tel='.$tel.'&datedebut='.$datedebut.'&datefin='.$datefin.'"><button type="button" class="btn btn-info">Modifier</button></a><br /></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');
	/* correspond au fail de la première requete */

	/* Fetch de la première ligne */
	$idresa = pg_fetch_assoc($rs)['idoutil'];

	/* Test de la première ligne vide ou pas */
	if (!empty($idresa))
	{
		/* La requête permetant d'inserer la reservation et execution de la requête */
		$query = "INSERT INTO RESERVATION VALUES (".$idresa.",".$dd.",".$df.",'".$nom."','".$prenom."','".$tel."','".$email."');"; 
		$rs = pg_query($con, $query) or die('<div class="alert alert-danger" role="alert"><p>La validation de la réservation à échoué, veuillez verifier vos champs date en appuyant sur modifier.</p></div><a href="ficheOutil.php?pdt='.$pdt.'&nom='.$nom.'&prenom='.$prenom.'&email='.$email.'&tel='.$tel.'&datedebut='.$datedebut.'&datefin='.$datefin.'"><button type="button" class="btn btn-info">Modifier</button></a><br /></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');
		/* correspond au fail de la deuxieme requete */

		$codeerreur = 1; /* Correspond à la reussite du post */
	}
	else
	{
		$codeerreur = 2; /* Correspond à l'indisponibilité du produit à ces date */
	}

	/* Fermeture de la connexion à la base de données */
	pg_close($con);
?>