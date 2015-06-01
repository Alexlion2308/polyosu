<!DOCTYPE html>
<html lang="fr">
<?php include("head-pages.php");?>
<body>
<?php include('header-pages.html'); ?>
<div class="container">    
    <div class="row">
        <div class="box">
            <div class="col-lg-12">
            	<h1 class="categorie">Liste des catégories</h1>
				<?php include('../php/getCategorie.php') ?>
			</div>
		</div>
	</div>
</div>
<?php include('footer-pages.html') ; ?>
<?php include('scripts-pages.php'); ?>
</body>
</html>